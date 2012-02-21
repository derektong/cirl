/*

A jQuery edit in place plugin

Version 2.3.0

Authors:
    Dave Hauenstein
    Martin Häcker <spamfaenger [at] gmx [dot] de>

Project home:
    http://code.google.com/p/jquery-in-place-editor/

Patches with tests welcomed! For guidance see the tests  </spec/unit/>. To submit, attach them to the bug tracker.

License:
This source file is subject to the BSD license bundled with this package.
Available online: {@link http://www.opensource.org/licenses/bsd-license.php}
If you did not receive a copy of the license, and are unable to obtain it, 
learn to use a search engine.

*/

(function($){

$.fn.editInPlace = function(options) {
    
    var settings = $.extend({}, $.fn.editInPlace.defaults, options);
    assertMandatorySettingsArePresent(settings);
    preloadImage(settings.saving_image);
    
    return this.each(function() {
        var dom = $(this);
        // This won't work with live queries as there is no specific element to attach this
        // one way to deal with this could be to store a reference to self and then compare that in click?
        if (dom.data('editInPlace'))
            return; // already an editor here
        dom.data('editInPlace', true);
        
        new InlineEditor(settings, dom).init();
    });
};

/// Switch these through the dictionary argument to $(aSelector).editInPlace(overideOptions)
/// Required Options: Either url or callback, so the editor knows what to do with the edited values.
$.fn.editInPlace.defaults = {
    regex:              "", // regular expression that text must match
    url:				"", // string: POST URL to send edited content
    bg_over:			"#fff", // string: background color of hover of unactivated editor
    bg_out:				"transparent", // string: background color on restore from hover
    hover_class:		"",  // string: class added to root element during hover. Will override bg_over and bg_out
    show_buttons:		false, // boolean: will show the buttons: cancel or save; will automatically cancel out the onBlur functionality
    save_button:		'<button class="inplace_save btn">Save</button>', // string: image button tag to use as “Save” button
    cancel_button:		'<button class="inplace_cancel btn">Cancel</button>', // string: image button tag to use as “Cancel” button
    delete_button:		'<button class="inplace_delete btn">Delete</button>', // string: image button tag to use as “Cancel” button
    params:				"", // string: example: first_name=dave&last_name=hauenstein extra paramters sent via the post request to the server
    field_type:			"text", // string: "text", "textarea", or "select";  The type of form field that will appear on instantiation
    default_text:		"(Click here to add text)", // string: text to show up if the element that has this functionality is empty
    use_html:			false, // boolean, set to true if the editor should use jQuery.fn.html() to extract the value to show from the dom node
    textarea_rows:		10, // integer: set rows attribute of textarea, if field_type is set to textarea. Use CSS if possible though
    textarea_cols:		25, // integer: set cols attribute of textarea, if field_type is set to textarea. Use CSS if possible though
    select_id:          "",
    select_value:		"", // string or array: Used if field_type is set to 'select'. Can be comma delimited list of options 'textandValue,text:value', Array of options ['textAndValue', 'text:value'] or array of arrays ['textAndValue', ['text', 'value']]. The last form is especially usefull if your labels or values contain colons)
    select_value:		"", // string or array: Used if field_type is set to 'select'. Can be comma delimited list of options 'textandValue,text:value', Array of options ['textAndValue', 'text:value'] or array of arrays ['textAndValue', ['text', 'value']]. The last form is especially usefull if your labels or values contain colons)
    text_size:			null, // integer: set cols attribute of text input, if field_type is set to text. Use CSS if possible though
    
    // Specifying callback_skip_dom_reset will disable all saving_* options
    saving_text:		undefined, // string: text to be used when server is saving information. Example "Saving..."
    saving_image:		"", // string: uses saving text specify an image location instead of text while server is saving
    saving_animation_color: 'transparent', // hex color string, will be the color the pulsing animation during the save pulses to. Note: Only works if jquery-ui is loaded
    
    value_required:		true, // boolean: if set to true, the element will not be saved unless a value is entered
    id:			"id", // string: name of parameter holding the id or the editable
    update_value:		"update_value", // string: name of parameter holding the updated/edited value
    original_value:		'original_value', // string: name of parameter holding the updated/edited value
    original_html:		"original_html", // string: name of parameter holding original_html value of the editable /* DEPRECATED in 2.2.0 */ use original_value instead.
    save_if_nothing_changed:	false,  // boolean: submit to function or server even if the user did not change anything
    on_blur:			"save", // string: "save" or null; what to do on blur; will be overridden if show_buttons is true
    cancel:				"", // string: if not empty, a jquery selector for elements that will not cause the editor to open even though they are clicked. E.g. if you have extra buttons inside editable fields
    
    // All callbacks will have this set to the DOM node of the editor that triggered the callback
    
    callback:			null, // function: function to be called when editing is complete; cancels ajax submission to the url param. Prototype: function(idOfEditor, enteredText, orinalHTMLContent, settingsParams, callbacks). The function needs to return the value that should be shown in the dom. Returning undefined means cancel and will restore the dom and trigger an error. callbacks is a dictionary with two functions didStartSaving and didEndSaving() that you can use to tell the inline editor that it should start and stop any saving animations it has configured. /* DEPRECATED in 2.1.0 */ Parameter idOfEditor, use $(this).attr('id') instead
    callback_skip_dom_reset: false, // boolean: set this to true if the callback should handle replacing the editor with the new value to show
    success:			null, // function: this function gets called if server responds with a success. Prototype: function(newEditorContentString)
    error:				null, // function: this function gets called if server responds with an error. Prototype: function(request)
    error_sink:			function(idOfEditor, errorString) { alert(errorString); }, // function: gets id of the editor and the error. Make sure the editor has an id, or it will just be undefined. If set to null, no error will be reported. /* DEPRECATED in 2.1.0 */ Parameter idOfEditor, use $(this).attr('id') instead
    preinit:			null, // function: this function gets called after a click on an editable element but before the editor opens. If you return false, the inline editor will not open. Prototype: function(currentDomNode). DEPRECATED in 2.2.0 use delegate shouldOpenEditInPlace call instead
    postclose:			null, // function: this function gets called after the inline editor has closed and all values are updated. Prototype: function(currentDomNode). DEPRECATED in 2.2.0 use delegate didCloseEditInPlace call instead
    delegate:			null // object: if it has methods with the name of the callbacks documented below in delegateExample these will be called. This means that you just need to impelment the callbacks you are interested in.
};

// Lifecycle events that the delegate can implement
// this will always be fixed to the delegate
var delegateExample = {
    // called while opening the editor.
    // return false to prevent editor from opening
    shouldOpenEditInPlace: function(aDOMNode, aSettingsDict, triggeringEvent) {},
    // return content to show in inplace editor
    willOpenEditInPlace: function(aDOMNode, aSettingsDict) {},
    didOpenEditInPlace: function(aDOMNode, aSettingsDict) {},
    
    // called while closing the editor
    // return false to prevent the editor from closing
    shouldCloseEditInPlace: function(aDOMNode, aSettingsDict, triggeringEvent) {},
    // return value will be shown during saving
    willCloseEditInPlace: function(aDOMNode, aSettingsDict) {},
    didCloseEditInPlace: function(aDOMNode, aSettingsDict) {},
    
    missingCommaErrorPreventer:''
};


function InlineEditor(settings, dom) {
    this.settings = settings;
    this.dom = dom;
    this.originalValue = null;
    this.didInsertDefaultText = false;
    this.shouldDelayReinit = false;
};

$.extend(InlineEditor.prototype, {
    
    init: function() {
        this.setDefaultTextIfNeccessary();
        this.connectOpeningEvents();
    },
    
    reinit: function() {
        if (this.shouldDelayReinit)
            return;
        
        this.triggerCallback(this.settings.postclose, /* DEPRECATED in 2.1.0 */ this.dom);
        this.triggerDelegateCall('didCloseEditInPlace');
        
        this.markEditorAsInactive();
        this.connectOpeningEvents();
    },
    
    setDefaultTextIfNeccessary: function() {
        if('' !== this.dom.html())
            return;
        
        this.dom.html(this.settings.default_text);
        this.didInsertDefaultText = true;
    },
    
    connectOpeningEvents: function() {
        var that = this;
        this.dom
            .bind('mouseenter.editInPlace', function(){ that.addHoverEffect(); })
            .bind('mouseleave.editInPlace', function(){ that.removeHoverEffect(); })
            .bind('click.editInPlace', function(anEvent){ that.openEditor(anEvent); });
    },
    
    disconnectOpeningEvents: function() {
        // prevent re-opening the editor when it is already open
        this.dom.unbind('.editInPlace');
    },
    
    addHoverEffect: function() {
        if (this.settings.hover_class)
            this.dom.addClass(this.settings.hover_class);
        else
            this.dom.css("background-color", this.settings.bg_over);
    },
    
    removeHoverEffect: function() {
        if (this.settings.hover_class)
            this.dom.removeClass(this.settings.hover_class);
        else
            this.dom.css("background-color", this.settings.bg_out);
    },
    
    openEditor: function(anEvent) {
        if ( ! this.shouldOpenEditor(anEvent))
            return;
        
        this.disconnectOpeningEvents();
        this.removeHoverEffect();
        this.removeInsertedDefaultTextIfNeccessary();
        this.saveOriginalValue();
        this.markEditorAsActive();
        this.replaceContentWithEditor();
        this.setInitialValue();
        this.workAroundMissingBlurBug();
        this.connectClosingEventsToEditor();
        this.triggerDelegateCall('didOpenEditInPlace');
    },
    
    shouldOpenEditor: function(anEvent) {
        if (this.isClickedObjectCancelled(anEvent.target))
            return false;
        
        if (false === this.triggerCallback(this.settings.preinit, /* DEPRECATED in 2.1.0 */ this.dom))
            return false;
        
        if (false === this.triggerDelegateCall('shouldOpenEditInPlace', true, anEvent))
            return false;
        
        return true;
    },
    
    removeInsertedDefaultTextIfNeccessary: function() {
        if ( ! this.didInsertDefaultText
            || this.dom.html() !== this.settings.default_text)
            return;
        
        this.dom.html('');
        this.didInsertDefaultText = false;
    },
    
    isClickedObjectCancelled: function(eventTarget) {
        if ( ! this.settings.cancel)
            return false;
        
        var eventTargetAndParents = $(eventTarget).parents().andSelf();
        var elementsMatchingCancelSelector = eventTargetAndParents.filter(this.settings.cancel);
        return 0 !== elementsMatchingCancelSelector.length;
    },
    
    saveOriginalValue: function() {
        if (this.settings.use_html)
            this.originalValue = this.dom.html();
        else
            this.originalValue = trim(this.dom.text());
    },
    
    restoreOriginalValue: function() {
        this.setClosedEditorContent(this.originalValue);
    },
    
    setClosedEditorContent: function(aValue) {
        this.dom.html(aValue);
        this.dom.parent().find(".tip").css( 'display', 'inline' );
    },
    
    workAroundMissingBlurBug: function() {
        // Strangely, all browser will forget to send a blur event to an input element
        // when another one is created and selected programmatically. (at least under some circumstances). 
        // This means that if another inline editor is opened, existing inline editors will _not_ close 
        // if they are configured to submit when blurred.
        
        // Using parents() instead document as base to workaround the fact that in the unittests
        // the editor is not a child of window.document but of a document fragment
        var ourInput = this.dom.find(':input');
        this.dom.parents(':last').find('.editInPlace-active :input').not(ourInput).blur();
    },
    
    replaceContentWithEditor: function() {
        var buttons_html  = (this.settings.show_buttons) ? '<div class="inplace_buttons">' + this.settings.save_button + ' ' + this.settings.cancel_button + ' ' + this.settings.delete_button + '</div>' : '';
        var editorElement = this.createEditorElement(); // needs to happen before anything is replaced
        var errorSpan = '<span class="inplace_error"></span>';
        /* insert the new in place form after the element they click, then empty out the original element */
        this.dom.html('<form class="inplace_form" style="display: inline; margin: 0; padding: 0;"></form>')
            .find('form')
                .append(editorElement)
                .append(errorSpan);
        this.dom.parent().find(".tip").css( 'display', 'none' );

        if( this.settings.field_type == "jurisdiction" ) {
          var element_id = this.dom.attr("id").split(" ");
          var issue_id = element_id[0];
          var jurisdiction_id = element_id[1];
          var form = this.dom.find("form");
          form.append( '<br /><select name="inplace_value" class="inplace_select"><option disabled="true" value="">' + this.settings.select_text + '</option></select>' );
          var editor = form.find(".inplace_select");

          $.ajax({
             dataType: "json",
             cache: false,
             url: '/jurisdictions/get_jurisdictions/' + jurisdiction_id,
             timeout: 2000,
             error: function(XMLHttpRequest, errorTextStatus, error){
                 alert("Failed to submit : "+ errorTextStatus+" ;"+error);
             },
             success: function(data){

              var row = null;
              var selected = "";
              $.each(data, function(i, j){
                if( j.id == jurisdiction_id )
                  selected = " selected";
                row = "<option value=\"" + j.id + "\"" + selected + ">" + j.name + "</option>";
                editor.append(row);
                selected = "";
              });
              
              return editor;
             }
          });
        }
        
        this.dom.find("form").append(buttons_html);
    },
    
    createEditorElement: function() {
        if (-1 === $.inArray(this.settings.field_type, ['text', 'textarea', 'select', 'jurisdiction']))
            throw "Unknown field_type <fnord>, supported are 'text', 'textarea' and 'select'";
        
        var editor = null;
        var textEditor = '<input type="text" ' + this.inputNameAndClass() 
                + ' size="' + this.settings.text_size  + '" />';
        if ("text" === this.settings.field_type)
            editor = textEditor;
        else if ("jurisdiction" === this.settings.field_type) {
            editor = textEditor;
        }
        else if ("textarea" === this.settings.field_type)
            editor = $('<textarea ' + this.inputNameAndClass() 
                + ' rows="' + this.settings.textarea_rows + '" '
                + ' cols="' + this.settings.textarea_cols + '" />');

        return editor;
    },
    
    setInitialValue: function() {
        var initialValue = this.triggerDelegateCall('willOpenEditInPlace', this.originalValue);
        var editor = this.dom.find(':input');
        editor.val(initialValue);
    },
    
    inputNameAndClass: function() {
        return ' name="inplace_value" class="inplace_field" ';
    },
    
    createSelectEditor: function() {


    },
    
    connectClosingEventsToEditor: function() {
        var that = this;
        function cancelEditorAction(anEvent) {
            that.handleCancelEditor(anEvent);
            return false; // stop event bubbling
        }
        function saveEditorAction(anEvent) {
            that.handleSaveEditor(anEvent);
            return false; // stop event bubbling
        }
        function deleteEditorAction(anEvent) {
            that.handleDeleteEditor(anEvent);
            return false; // stop event bubbling
        }
        
        var form = this.dom.find("form");
        
        form.find(".inplace_field").focus().select();
        form.find(".inplace_cancel").click(cancelEditorAction);
        form.find(".inplace_save").click(saveEditorAction);
        form.find(".inplace_delete").click(deleteEditorAction);
        
        if ( ! this.settings.show_buttons) {
                // TODO: Firefox has a bug where blur is not reliably called when focus is lost 
                //       (for example by another editor appearing)
            if ("save" === this.settings.on_blur)
                form.find(".inplace_field").blur(saveEditorAction);
            else
                form.find(".inplace_field").blur(cancelEditorAction);
            
            // workaround for msie & firefox bug where it won't submit on enter if no button is shown
            if ($.browser.mozilla || $.browser.msie)
                this.bindSubmitOnEnterInInput();
        }
        
        form.keyup(function(anEvent) {
            // allow canceling with escape
            var escape = 27;
            if (escape === anEvent.which)
                return cancelEditorAction();
        });
        
        // workaround for webkit nightlies where they won't submit at all on enter
        // REFACT: find a way to just target the nightlies
        if ($.browser.safari)
            this.bindSubmitOnEnterInInput();
        
        form.submit(saveEditorAction);
    },
    
    bindSubmitOnEnterInInput: function() {
        if ('textarea' === this.settings.field_type)
            return; // can't enter newlines otherwise
        
        var that = this;
        this.dom.find(':input').keyup(function(event) {
            var enter = 13;
            if (enter === event.which)
                return that.dom.find('form').submit();
        });
        
    },
    
    handleCancelEditor: function(anEvent) {
        // REFACT: remove duplication between save and cancel
        if (false === this.triggerDelegateCall('shouldCloseEditInPlace', true, anEvent))
            return;
        
        var enteredText = this.dom.find(':input').val();
        enteredText = this.triggerDelegateCall('willCloseEditInPlace', enteredText);
        
        this.restoreOriginalValue();
        //if (hasContent(enteredText) 
        //    && ! this.isDisabledDefaultSelectChoice())
        //    this.setClosedEditorContent(enteredText);
        this.reinit();
    },
    
    handleDeleteEditor: function(anEvent) {
        // REFACT: remove duplication between save and cancel
        if (false === this.triggerDelegateCall('shouldCloseEditInPlace', true, anEvent))
            return;
        
        var enteredText = this.dom.find(':input').val();
        enteredText = this.triggerDelegateCall('willCloseEditInPlace', enteredText);

        
        if ( confirm("Are you sure you want to delete this entry?") ) {
          var id = this.dom.attr("id");
          if( this.settings.field_type == "jurisdiction" ) {
            id = id.split(" ")[0];
          }
          var url = this.settings.url.replace('/edit', '/' + this.dom.attr("id"));
          $.ajax({
            url: url.replace('/edit', ''),
            type: 'post',
            dataType: 'script',
            data: { '_method': 'delete' },
          });
        }

        return;
    },
    
    handleSaveEditor: function(anEvent) {
        if (false === this.triggerDelegateCall('shouldCloseEditInPlace', true, anEvent))
            return;
        
        var enteredText = this.dom.find(':input').val();
        var selectOption = "";
        if( this.settings.field_type == "jurisdiction" )
        {
          selectOption = this.dom.find('.inplace_select').val();
        }


        enteredText = this.triggerDelegateCall('willCloseEditInPlace', enteredText);
        
        /* won't work for select box change but not text
        if (this.isDisabledDefaultSelectChoice()
            || this.isUnchangedInput(enteredText)) {
            this.handleCancelEditor(anEvent);
            return;
        }*/
        
        if (this.didForgetRequiredText(enteredText)) {
            this.showErrorMessage("cannot be blank");
            return;
        }

        var regularExpression = new RegExp( this.settings.regex );
        if (enteredText.search( regularExpression ) == -1 ) {
            this.showErrorMessage("can only contain letters and numbers");
            return;
        }
        
        this.showSaving(enteredText);
        
        if (this.settings.callback)
            this.handleSubmitToCallback(enteredText);
        else
            this.handleSubmitToServer(enteredText, selectOption);
    },

    showErrorMessage: function(message) {
        this.reportError(message);
        var form = this.dom.find("form");
        form.find(".inplace_error").text(message);
        form.find(".inplace_error").css('display', 'block');
    },
    
    didForgetRequiredText: function(enteredText) {
        return this.settings.value_required 
            && ("" === enteredText 
                || undefined === enteredText
                || null === enteredText);
    },
    
    isDisabledDefaultSelectChoice: function() {
        return this.dom.find('option').eq(0).is(':selected:disabled');
    },
    
    isUnchangedInput: function(enteredText) {
        return ! this.settings.save_if_nothing_changed
            && this.originalValue === enteredText;
    },
    
    showSaving: function(enteredText) {
        if (this.settings.callback && this.settings.callback_skip_dom_reset)
            return;
        
        var savingMessage = enteredText;
        if (hasContent(this.settings.saving_text))
            savingMessage = this.settings.saving_text;
        if(hasContent(this.settings.saving_image))
            // REFACT: alt should be the configured saving message
            savingMessage = $('<img />').attr('src', this.settings.saving_image).attr('alt', savingMessage);
        this.dom.html(savingMessage);
    },
    
    handleSubmitToCallback: function(enteredText) {
        // REFACT: consider to encode enteredText and originalHTML before giving it to the callback
        this.enableOrDisableAnimationCallbacks(true, false);
        var newHTML = this.triggerCallback(this.settings.callback, /* DEPRECATED in 2.1.0 */ this.id(), enteredText, this.originalValue, 
            this.settings.params, this.savingAnimationCallbacks());
        
        if (this.settings.callback_skip_dom_reset)
            ; // do nothing
        else if (undefined === newHTML) {
            // failure; put original back
            this.reportError("Error: Failed to save value: " + enteredText);
            this.restoreOriginalValue();
        }
        else
            // REFACT: use setClosedEditorContent
            this.dom.html(newHTML);
        
        if (this.didCallNoCallbacks()) {
            this.enableOrDisableAnimationCallbacks(false, false);
            this.reinit();
        }
    },
    
    handleSubmitToServer: function(enteredText, selectOption) {
        var element_id = this.dom.attr("id").split(" ");
        var issue_id = element_id[0];
        var data = this.settings.update_value + '=' + encodeURIComponent(enteredText) 
            + '&' + this.settings.id + '=' + issue_id 
            + ((this.settings.params) ? '&' + this.settings.params : '')
            + '&' + this.settings.select_id + '=' + selectOption
            + '&' + this.settings.original_html + '=' + encodeURIComponent(this.originalValue) /* DEPRECATED in 2.2.0 */
            + '&' + this.settings.original_value + '=' + encodeURIComponent(this.originalValue);
        
        this.enableOrDisableAnimationCallbacks(true, false);
        this.didStartSaving();
        var that = this;
        var newText = enteredText;
        this.dom.html(newText);
        this.dom.parent().find(".tip").css( 'display', 'inline' );
        $.ajax({
            url: that.settings.url,
            type: "POST",
            data: data,
            dataType: "html",
            complete: function(request){
                that.didEndSaving();
            },
            success: function(){
                //var new_text = html || that.settings.default_text;
                //var tip_html = '<span class="tip">(click to edit)</span>';
                
                /* put the newly updated info into the original element */
                // FIXME: should be affected by the preferences switch
                //that.dom.html("<p>" + newText + tip_html + "</p>");

                // REFACT: remove dom parameter, already in this, not documented, should be easy to remove
                // REFACT: callback should be able to override what gets put into the DOM
                //that.triggerCallback(that.settings.success, html);
            },
            error: function(request) {
                //that.dom.html(that.originalValue); // REFACT: what about a restorePreEditingContent()
                //if (that.settings.error)
                    // REFACT: remove dom parameter, already in this, not documented, can remove without deprecation
                    // REFACT: callback should be able to override what gets entered into the DOM
                //    that.triggerCallback(that.settings.error, request);
                //else
                //    that.reportError("Failed to save value: " + request.responseText || 'Unspecified Error');
            }
        });
    },
    
    // Utilities .........................................................
    
    triggerCallback: function(aCallback /*, arguments */) {
        if ( ! aCallback)
            return; // callback wasn't specified after all
        
        var callbackArguments = Array.prototype.slice.call(arguments, 1);
        return aCallback.apply(this.dom[0], callbackArguments);
    },
    
    /// defaultReturnValue is only used if the delegate returns undefined
    triggerDelegateCall: function(aDelegateMethodName, defaultReturnValue, optionalEvent) {
        // REFACT: consider to trigger equivalent callbacks automatically via a mapping table?
        if ( ! this.settings.delegate
            || ! $.isFunction(this.settings.delegate[aDelegateMethodName]))
            return defaultReturnValue;
        
        var delegateReturnValue =  this.settings.delegate[aDelegateMethodName](this.dom, this.settings, optionalEvent);
        return (undefined === delegateReturnValue)
            ? defaultReturnValue
            : delegateReturnValue;
    },
    
    reportError: function(anErrorString) {
        this.triggerCallback(this.settings.error_sink, /* DEPRECATED in 2.1.0 */ this.id(), anErrorString);
    },
    
    // REFACT: this method should go, callbacks should get the dom node itself as an argument
    id: function() {
        return this.dom.attr('id');
    },
    
    markEditorAsActive: function() {
        this.dom.addClass('editInPlace-active');
    },
    
    markEditorAsInactive: function() {
        this.dom.removeClass('editInPlace-active');
    },
    
    // REFACT: consider rename, doesn't deal with animation directly
    savingAnimationCallbacks: function() {
        var that = this;
        return {
            didStartSaving: function() { that.didStartSaving(); },
            didEndSaving: function() { that.didEndSaving(); }
        };
    },
    
    enableOrDisableAnimationCallbacks: function(shouldEnableStart, shouldEnableEnd) {
        this.didStartSaving.enabled = shouldEnableStart;
        this.didEndSaving.enabled = shouldEnableEnd;
    },
    
    didCallNoCallbacks: function() {
        return this.didStartSaving.enabled && ! this.didEndSaving.enabled;
    },
    
    assertCanCall: function(methodName) {
        if ( ! this[methodName].enabled)
            throw new Error('Cannot call ' + methodName + ' now. See documentation for details.');
    },
    
    didStartSaving: function() {
        this.assertCanCall('didStartSaving');
        this.shouldDelayReinit = true;
        this.enableOrDisableAnimationCallbacks(false, true);
        
        this.startSavingAnimation();
    },
    
    didEndSaving: function() {
        this.assertCanCall('didEndSaving');
        this.shouldDelayReinit = false;
        this.enableOrDisableAnimationCallbacks(false, false);
        this.reinit();
        
        this.stopSavingAnimation();
    },
    
    startSavingAnimation: function() {
        var that = this;
        this.dom
            .animate({ backgroundColor: this.settings.saving_animation_color }, 400)
            .animate({ backgroundColor: 'transparent'}, 400, 'swing', function(){
                // In the tests animations are turned off - i.e they happen instantaneously.
                // Hence we need to prevent this from becomming an unbounded recursion.
                setTimeout(function(){ that.startSavingAnimation(); }, 10);
            });
    },
    
    stopSavingAnimation: function() {
        this.dom
            .stop(true)
            .css({backgroundColor: ''});
    },
    
    missingCommaErrorPreventer:''
});



// Private helpers .......................................................

function assertMandatorySettingsArePresent(options) {
    // one of these needs to be non falsy
    if (options.url || options.callback)
        return;
    
    throw new Error("Need to set either url: or callback: option for the inline editor to work.");
}

/* preload the loading icon if it is configured */
function preloadImage(anImageURL) {
    if ('' === anImageURL)
        return;
    
    var loading_image = new Image();
    loading_image.src = anImageURL;
}

function trim(aString) {
    return aString
        .replace(/^\s+/, '')
        .replace(/\s+$/, '');
}

function hasContent(something) {
    if (undefined === something || null === something)
        return false;
    
    if (0 === something.length)
        return false;
    
    return true;
}

})(jQuery);

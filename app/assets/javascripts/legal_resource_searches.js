$(document).ready(function(){

  // show hide advanced options
  var toggle = $(".show_hide");
  var multipleselect = true;
  var headerselect = true;

  toggle.click(function(){
    $(".slider").slideToggle();
    if( toggle.text().indexOf("Show") != -1 ) {
      toggle.text("Hide advanced options");
      $("#advanced").val( "block" );
    }
    else {
      $("select#legal_resource_search_document_type_ids").multiselect('uncheckAll');
      $("select#legal_resource_search_document_type_ids").multiselect('disable');
      $("select#legal_resource_search_publisher_ids").multiselect('uncheckAll');
      $("select#legal_resource_search_process_topic_ids").multiselect('uncheckAll');
      $("select#legal_resource_search_child_topic_ids").multiselect('uncheckAll');
      $("select#legal_resource_search_refugee_topic_ids").multiselect('uncheckAll');
      $("select#legal_resource_search_keyword_ids").multiselect('uncheckAll');
      $("select#legal_resource_day_from").val("");
      $("select#legal_resource_month_from").val("");
      $("select#legal_resource_year_from").val("");
      $("select#legal_resource_day_to").val("");
      $("select#legal_resource_month_to").val("");
      $("select#legal_resource_year_to").val("");
      toggle.text("Show advanced options");
      $("#advanced").val( "none" );
    }
  });

  // multiselect options

  $("select#legal_resource_search_document_type_ids").multiselect({
    multiple: multipleselect,
    header: headerselect,
    noneSelectedText: "Select document_types",
    selectedList: 10,
    open: function() {
      $("#document_type_popper").tooltip('show');
    },
    close: function() {
      $("#document_type_popper").tooltip('hide');
    },
  });

  $("select#legal_resource_search_process_topic_ids").multiselect({
    multiple: true,
    header: true,
    noneSelectedText: "Select topics",
    selectedList: 10,
    open: function() {
      $("#process_topic_popper").tooltip('show');
    },
    close: function() {
      $("#process_topic_popper").tooltip('hide');
    },
  });

  $("select#legal_resource_search_child_topic_ids").multiselect({
    multiple: true,
    header: true,
    noneSelectedText: "Select topics",
    selectedList: 10,
    open: function() {
      $("#child_topic_popper").tooltip('show');
    },
    close: function() {
      $("#child_topic_popper").tooltip('hide');
    },
  });

  $("select#legal_resource_search_refugee_topic_ids").multiselect({
    multiple: true,
    header: true,
    noneSelectedText: "Select topics",
    selectedList: 10,
    open: function() {
      $("#refugee_topic_popper").tooltip('show');
    },
    close: function() {
      $("#refugee_topic_popper").tooltip('hide');
    },
  });

  $("select#legal_resource_search_keyword_ids").multiselect({
    multiple: true,
    header: true,
    noneSelectedText: "Select keywords",
    selectedList: 10,
    open: function() {
      $("#keyword_popper").tooltip('show');
    },
    close: function() {
      $("#keyword_popper").tooltip('hide');
    },
  });

  // start with the document_types dropdown disabled
  $("select#legal_resource_search_document_type_ids").multiselect('disable');

  // publisher dropdown needs to trigger document_type dropdown
  $("select#legal_resource_search_publisher_ids").multiselect({
    multiple: multipleselect,
    header: headerselect,
    noneSelectedText: "Select a publisher",
    selectedList: 10,

    open: function() {
      $("#publisher_popper").tooltip('show');
    },

    close: function() {
    // $("select#legal_resource_search_publisher").change(function(){
        var id_value_string = $(this).val();
        $("#publisher_popper").tooltip('hide');

        // need to check null and blank in legal_resource jqueryui does not work
        if (id_value_string == null || id_value_string == "") {
            // if the id is empty remove all the sub_selection options from being selectable and do not do any ajax
            $("select#legal_resource_search_document_type_ids").attr('disabled', true);
            $("select#legal_resource_search_document_type_ids").multiselect('disable');
            $("select#legal_resource_search_document_type_ids option").remove();
            var row = "<option value=\"\">(Select a document_type)</option>";
            $(row).appendTo("select#legal_resource_search_document_type_ids");
        }
        else {
            // Send the request and update sub category dropdown
            $.ajax({
                dataType: "json",
                cache: false,
                url: '/document_types/for_publisher_id/' + id_value_string,
                timeout: 2000,
                error: function(XMLHttpRequest, errorTextStatus, error){
                    alert("Failed to submit : "+ errorTextStatus+" ;"+error);
                },
                success: function(data){                    
                    // Clear all options from sub category select
                    $("select#legal_resource_search_document_type_ids option").remove();
                    $("select#legal_resource_search_document_type_ids optgroup").remove();

                    var row = "";
                    var current_publisher = "";

                    //put in a empty default line
                    if( $.isArray(id_value_string) )
                      {}
                    else {
                      row = "<option value=\"\">(Select a document_type)</option>";
                      $(row).appendTo("select#legal_resource_document_type_id");                        
                    }

                    // Fill sub category select
                    $.each(data, function(i, j){

                      // Put in optgroups if in multiple selection mode
                      if( $.isArray(id_value_string) && 
                          j.publisher.name !== current_publisher) {
                            current_publisher = j.publisher.name;
                            row = "<optgroup id=\"" + j.publisher.id +
                                  "\" label=\"" + current_publisher + "\">";
                            $("select#legal_resource_search_document_type_ids").append(row);    
                          }


                      row = "<option value=\"" + j.id + "\">" + j.name + "</option>";

                      if( $.isArray(id_value_string) )  
                        $("optgroup#" + j.publisher.id).append(row); 
                      else 
                        $(row).appendTo("select#legal_resource_search_document_type_ids");    

                    });            
                    
                    // refresh
                    $("select#legal_resource_search_document_type_ids").multiselect('refresh');
                    $("select#legal_resource_search_document_type_ids").multiselect('enable');
                    $("select#legal_resource_search_document_type_ids").multiselect('uncheckAll');
                    $("select#legal_resource_search_document_type_ids").attr('disabled', false);
                 }
            });
        };
    }

  });

  // disable or enable document_type box 
  if( $("select#legal_resource_search_publisher_ids").val() == null || $("select#legal_resource_search_publisher_ids").val() == "" ) 
    $("select#legal_resource_search_document_type_ids").multiselect('disable');
  else
    $("select#legal_resource_search_document_type_ids").multiselect('enable');

  // enable popups
  $(".popper").tooltip({
    placement: 'right',
    trigger: 'focus'
  });

  // enable dynamic button
  $(".try").button();

});

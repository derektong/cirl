$(document).ready(function(){

  // enabled "required" checkboxes so they are included in the submit
  $('form.change_legal_brief').submit(function() {
    $('input[type=checkbox]').each( function() {
      if( $(this).attr('id') == "legal_brief_keyword_ids_" ) 
        $(this).removeAttr("disabled");
    });
  });

  $("select#legal_brief_jurisdiction_id").change(function(){
    var id_value_string = $(this).val();

    // need to check null and blank in legal_brief jqueryui does not work
    if (id_value_string == null || id_value_string == "") {
      // if the id is empty remove all the sub_selection options from being selectable and do not do any ajax
      $("select#legal_brief_court_id").attr('disabled', true);
      $("select#legal_brief_court_id option").remove();
      var row = "<option value=\"\">(Select a court)</option>";
      $(row).appendTo("select#legal_brief_court_id");
    }
    else {
      // Send the request and update sub category dropdown
      $.ajax({
        dataType: "json",
        cache: false,
        url: '/courts/for_jurisdiction_id/' + id_value_string,
        timeout: 2000,
        error: function(XMLHttpRequest, errorTextStatus, error){
            alert("Failed to submit : "+ errorTextStatus+" ;"+error);
        },
        success: function(data){                    
          // Clear all options from sub category select
          $("select#legal_brief_court_id option").remove();

          var row = "<option value=\"\">(Select a court)</option>";
          $(row).appendTo("select#legal_brief_court_id");                        

          // Fill sub category select
          $.each(data, function(i, j){
            row = "<option value=\"" + j.id + "\">" + j.name + "</option>";
            $(row).appendTo("select#legal_brief_court_id");    
          });            
          
          // refresh
          $("select#legal_brief_court_id").attr('disabled', false);
        }
      });
    };
  });

  $(":checkbox").change(function(){
    if( $(this).attr('name') == 'legal_brief[keyword_ids][]' )
      return;

    var processVals = [-1];
    var childVals = [-1];
    var refugeeVals = [-1];

    $(':checked').each(function() {
      var name = $(this).attr('name');
 
      switch (name) {
        case 'legal_brief[process_topic_ids][]':
          processVals.push($(this).val());
        break;

        case 'legal_brief[child_topic_ids][]':
          childVals.push($(this).val());
        break;

        case 'legal_brief[refugee_topic_ids][]':
          refugeeVals.push($(this).val());
        break;
      }
    });

    $.ajax({
      dataType: "json",
      cache: false,
      url: '/keywords/' + processVals + '/' + childVals + '/' + refugeeVals,
      timeout: 20000,
      error: function(XMLHttpRequest, errorTextStatus, error){
          alert("Failed to submit : "+ errorTextStatus+" ;"+error);
      },
      success: function(data){                    
        $('.keyword_label').each(function() {
          $(this).removeClass( "keywordRecommended" );
        });

        $('input[type=checkbox]').each( function() {
          if( $(this).attr('id') == "legal_brief_keyword_ids_" ) {
            if( $(this).is(':disabled') ) {
              $(this).removeAttr("disabled");
              $(this).removeAttr("checked");
            }
          }
        });

        // if all options unselected, no need to run through iteration
        if( data.length === 0 )
          return;

        var keyword_id = "";
        $.each(data, function(i, j){

          keyword_id = "keyword_" + j.keyword_id
          $('#' + keyword_id).addClass( "keywordRecommended" );

          if( j.required == true ) {
            $('input[type=checkbox]').each( function() {
              if( $(this).val() == j.keyword_id ) {
                $(this).attr("checked", "checked");
                $(this).attr("disabled", true);
              }
            });
          }

        });            

      }
    });
  });


});


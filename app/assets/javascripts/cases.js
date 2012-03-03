$(document).ready(function(){

  $("select#case_court_id").multiselect({
    multiple: multipleselect,
    header: headerselect,
    noneSelectedText: "Select a court",
    selectedList: 4
  });

  $("select#case_court_id").multiselect('disable');

  $("select#case_jurisdiction_id").multiselect({
    multiple: multipleselect,
    header: headerselect,
    noneSelectedText: "Select a jurisdiction",
    selectedList: 4,

    close: function() {
    // $("select#case_jurisdiction_id").change(function(){
        var id_value_string = $(this).val();
        if (id_value_string == null) {
            // if the id is empty remove all the sub_selection options from being selectable and do not do any ajax
            $("select#case_court_id").attr('disabled', true);
            $("select#case_court_id").multiselect('disable');
            $("select#case_court_id option").remove();
            var row = "<option value=\"\">(Select a court)</option>";
            $(row).appendTo("select#case_court_id");
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
                    $("select#case_court_id option").remove();
                    $("select#case_court_id optgroup").remove();

                    //put in a empty default line
                    var row = "";
                    var current_jurisdiction = "";
                    if( $.isArray(id_value_string) ) {
                      current_jurisdiction = data[0].jurisdiction.name;
                      row = "<optgroup label=\"" + current_jurisdiction + "\">";
                    }

                    $(row).appendTo("select#case_court_id");                        

                    // Fill sub category select
                    $.each(data, function(i, j){

                      if( $.isArray(id_value_string) && 
                          j.jurisdiction.name !== current_jurisdiction) {
                            current_jurisdiction = j.jurisdiction.name;
                            row = "<optgroup label=\"" + current_jurisdiction + "\">";
                            $(row).appendTo("select#case_court_id");                    
                          }

                      row = "<option value=\"" + j.id + "\">" + j.name + "</option>";
                      $(row).appendTo("select#case_court_id optgroup");                    
                    });            
                    
                    // refresh
                    //$("select#case_court_id").multiselectfilter();
                    $("select#case_court_id").multiselect('refresh');
                    $("select#case_court_id").multiselect('enable');
                    $("select#case_court_id").attr('disabled', false);
                    alert ($("select#case_court_id").html());
                 }
            });
        };
    }

  });


  });

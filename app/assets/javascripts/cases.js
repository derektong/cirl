$(document).ready(function(){

  $("select#case_court_id").multiselect({
    multiple: multipleselect,
    header: headerselect,
    noneSelectedText: "Select courts",
    selectedList: 10,
  });

  $("select#case_subject_ids").multiselect({
    multiple: true,
    header: true,
    noneSelectedText: "Select legal subjects",
    selectedList: 10,
  });

  $("select#case_issue_ids").multiselect({
    multiple: true,
    header: true,
    noneSelectedText: "Select legal issues",
    selectedList: 10,
  });

  $("select#case_country_origin").multiselect({
    multiple: true,
    header: true,
    noneSelectedText: "Select countries of origin",
    selectedList: 10,
  });

  // start with all dropdowns unselected
  $("select#case_court_id").multiselect('uncheckAll');
  $("select#case_subject_ids").multiselect('uncheckAll');
  $("select#case_issue_ids").multiselect('uncheckAll');

  // start with the courts dropdown disabled
  $("select#case_court_id").multiselect('disable');

  // jurisdiction dropdown needs to trigger court dropdown
  $("select#case_jurisdiction_id").multiselect({
    multiple: multipleselect,
    header: headerselect,
    noneSelectedText: "Select a jurisdiction",
    selectedList: 10,

    close: function() {
    // $("select#case_jurisdiction_id").change(function(){
        var id_value_string = $(this).val();

        // need to check null and blank in case jqueryui does not work
        if (id_value_string == null || id_value_string == "") {
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
                      row = "<optgroup class=\"" + current_jurisdiction +
                            "\" label=\"" + current_jurisdiction + "\">";
                    }

                    $(row).appendTo("select#case_court_id");                        

                    // Fill sub category select
                    $.each(data, function(i, j){

                      if( $.isArray(id_value_string) && 
                          j.jurisdiction.name !== current_jurisdiction) {
                            current_jurisdiction = j.jurisdiction.name;
                            row = "<optgroup class=\"" + current_jurisdiction +
                                  "\" label=\"" + current_jurisdiction + "\">";
                            $(row).appendTo("select#case_court_id");    
                          }

                      row = "<option value=\"" + j.id + "\">" + j.name + "</option>";

                      if( $.isArray(id_value_string) )
                        $("optgroup." + current_jurisdiction).append(row);
                      else
                        $(row).appendTo("select#case_court_id");    

                    });            
                    
                    // refresh
                    $("select#case_court_id").multiselect('refresh');
                    $("select#case_court_id").multiselect('enable');
                    $("select#case_court_id").multiselect('uncheckAll');
                    $("select#case_court_id").attr('disabled', false);
                 }
            });
        };
    }

  });


  });

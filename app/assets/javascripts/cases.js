$(document).ready(function(){
    $("select#case_jurisdiction_id").change(function(){
        var id_value_string = $(this).val();
        if (id_value_string == "") {
            // if the id is empty remove all the sub_selection options from being selectable and do not do any ajax
            $("select#case_court_id").attr('disabled', true);
            $("select#case_court_id option").remove();
            var row = "<option value=\"" + "(Select a court)" + "\">" + "(Select a court)" + "</option>";
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
                    $("select#case_court_id").attr('disabled', false);
                    // Clear all options from sub category select
                    $("select#case_court_id option").remove();
                    //put in a empty default line
                    var row = "<option value=\"" + "" + "\">" + "(Select a court)" + "</option>";
                    $(row).appendTo("select#case_court_id");                        
                    // Fill sub category select
                    $.each(data, function(i, j){
                        row = "<option value=\"" + j.id + "\">" + j.name + "</option>";

                        $(row).appendTo("select#case_court_id");                    
                    });            
                 }
            });
        };
    });
});

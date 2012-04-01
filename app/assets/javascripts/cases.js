$(document).ready(function(){

  // show hide advanced options
  var toggle = $(".show_hide");

  toggle.click(function(){
    $(".slider").slideToggle();
    if( toggle.text().indexOf("Show") != -1 ) {
      toggle.text("Hide advanced options");
      $("#advanced").val( "block" );
    }
    else {
      $("select#case_court_id").multiselect('uncheckAll');
      $("select#case_court_id").multiselect('disable');
      $("select#case_jurisdiction_id").multiselect('uncheckAll');
      $("select#case_country_origin").multiselect('uncheckAll');
      $("select#case_child_topic_ids").multiselect('uncheckAll');
      $("select#case_refugee_topic_ids").multiselect('uncheckAll');
      $("select#case_keyword_ids").multiselect('uncheckAll');
      $("select#case_day_from").val("");
      $("select#case_month_from").val("");
      $("select#case_year_from").val("");
      $("select#case_day_to").val("");
      $("select#case_month_to").val("");
      $("select#case_year_to").val("");
      toggle.text("Show advanced options");
      $("#advanced").val( "none" );
    }
  });

  // multiselect options

  $("select#case_court_id").multiselect({
    multiple: multipleselect,
    header: headerselect,
    noneSelectedText: "Select courts",
    selectedList: 10,
    open: function() {
      $("#court_popper").tooltip('show');
    },
    close: function() {
      $("#court_popper").tooltip('hide');
    },
  });

  $("select#case_child_topic_ids").multiselect({
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

  $("select#case_refugee_topic_ids").multiselect({
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

  $("select#case_keyword_ids").multiselect({
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

  $("select#case_country_origin").multiselect({
    multiple: multipleselect,
    header: headerselect,
    noneSelectedText: "Select countries of origin",
    selectedList: 10,
    open: function() {
      $("#country_origin_popper").tooltip('show');
    },
    close: function() {
      $("#country_origin_popper").tooltip('hide');
    },
  });

  // start with the courts dropdown disabled
  $("select#case_court_id").multiselect('disable');

  // jurisdiction dropdown needs to trigger court dropdown
  $("select#case_jurisdiction_id").multiselect({
    multiple: multipleselect,
    header: headerselect,
    noneSelectedText: "Select a jurisdiction",
    selectedList: 10,

    open: function() {
      $("#jurisdiction_popper").tooltip('show');
    },

    close: function() {
    // $("select#case_jurisdiction_id").change(function(){
        var id_value_string = $(this).val();
        $("#jurisdiction_popper").tooltip('hide');

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

                    var row = "";
                    var current_jurisdiction = "";

                    //put in a empty default line
                    if( $.isArray(id_value_string) )
                      {}
                    else {
                      row = "<option value=\"\">(Select a court)</option>";
                      $(row).appendTo("select#case_court_id");                        
                    }

                    // Fill sub category select
                    $.each(data, function(i, j){

                      // Put in optgroups if in multiple selection mode
                      if( $.isArray(id_value_string) && 
                          j.jurisdiction.name !== current_jurisdiction) {
                            current_jurisdiction = j.jurisdiction.name;
                            row = "<optgroup id=\"" + j.jurisdiction.id +
                                  "\" label=\"" + current_jurisdiction + "\">";
                            $("select#case_court_id").append(row);    
                          }


                      row = "<option value=\"" + j.id + "\">" + j.name + "</option>";

                      if( $.isArray(id_value_string) )  
                        $("optgroup#" + j.jurisdiction.id).append(row); 
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

  // disable or enable court box 
  if( $("select#case_jurisdiction_id").val() == null || $("select#case_jurisdiction_id").val() == "" ) 
    $("select#case_court_id").multiselect('disable');
  else
    $("select#case_court_id").multiselect('enable');

  // enable popups
  $(".popper").tooltip({
    placement: 'right',
    trigger: 'focus'
  });

  // enable dynamic button
  $(".try").button();

});

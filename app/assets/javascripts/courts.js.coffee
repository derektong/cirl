$(document).ready ->
    $(".court_edit").editInPlace
        url:            '/courts/edit'
        regex:          '^[\\w\\-\\s]+$'
        show_buttons:   true
        field_type:     'jurisdiction'
        select_id:      'jurisdiction_id'
      

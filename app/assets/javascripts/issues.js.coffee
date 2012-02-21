$(document).ready ->
    $(".issue_edit").editInPlace
        url:            '/issues/edit'
        regex:          '^[\\w\\-\\s]+$',
        show_buttons:   true
      

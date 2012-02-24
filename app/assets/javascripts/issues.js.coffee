$(document).ready ->
    $(".issue_edit").editInPlace
        url:            '/issues/'
        regex:          '^[\\w\\-\\s]+$',
        show_buttons:   true
      

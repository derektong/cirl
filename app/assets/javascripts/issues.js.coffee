$(document).ready ->
    $(".issue_edit").editInPlace
        url:            '/issues/edit'
        regex:          '^\\w+$',
        show_buttons:   true
      

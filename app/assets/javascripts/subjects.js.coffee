$(document).ready ->
    $(".subject_edit").editInPlace
        url:            '/subjects/'
        regex:          '^[\\w\\-\\s]+$',
        show_buttons:   true
      

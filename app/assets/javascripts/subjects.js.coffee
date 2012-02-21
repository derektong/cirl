$(document).ready ->
    $(".subject_edit").editInPlace
        url:            '/subjects/edit'
        regex:          '^[\\w\\-\\s]+$',
        show_buttons:   true
      

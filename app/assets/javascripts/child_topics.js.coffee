$(document).ready ->
    $(".child_topic_edit").editInPlace
        url:            '/child_topics/'
        regex:          '^[\\w\\-\\s]+$',
        show_buttons:   true
      

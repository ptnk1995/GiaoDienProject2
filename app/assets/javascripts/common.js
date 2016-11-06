$(document).on('keyup click', 'input#search', function() {
  key_search = $(this).val();
  if (key_search.length > 0) {
    $.get($('#search_book').attr('action'), $('#search_book').serialize(),
      null, 'script');
    return false;
  } else {
    $('.list-group').slideUp();
  }
});
$(document).on('click', function() {
 $('.list-group').slideUp();
});
$(document).on('click', 'input#search', function(e) {
  e.stopPropagation();
});
$(document).on('keypress', '#search_book', function(event) {
  return event.keyCode != 13;
});
$(document).on('change', '.radio', function() {
  $(this).closest('form').submit();
});


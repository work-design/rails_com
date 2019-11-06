$('.ui.checkbox').checkbox()
$('.ui.progress').progress({
  duration: 3000
})
$('#flash_toast').transition({
  animation: 'fade',
  duration: '3s'
})

$('.message .close').on('click', function() {
  $(this).closest('.message').fadeOut();
})

$('form[method="get"]').submit(function(e) {
  for (var i = 0; i < this.elements.length; i++) {
    if ( this[i].value.length === 0 ) {
      this[i].disabled = true;
    }

    if ( this[i].name === 'commit' ) {
      this[i].disabled = true;
    }

    if ( this[i].name === 'utf8' ) {
      this[i].disabled = true;
    }
  }
})

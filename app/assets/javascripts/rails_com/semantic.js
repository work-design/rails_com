$('.ui.toggle.checkbox').checkbox();
$('.ui.progress').progress({
  duration: 3000
});
$('#flash_toast').transition({
  animation: 'fade',
  duration: '3s'
});

$('.message .close').on('click', function() {
  $(this).closest('.message').fadeOut();
});

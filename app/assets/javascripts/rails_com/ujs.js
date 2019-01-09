document.querySelectorAll('input[data-submit="true"]').forEach(function (el) {
  el.addEventListener('change', function () {
    this.dataset['params'] = this.name + '=' + this.checked;
  });
});
document.querySelectorAll('input[data-form="true"]').forEach(function (el) {
  el.addEventListener('change', function () {
    Rails.fire(this.form, 'submit');
  });
});

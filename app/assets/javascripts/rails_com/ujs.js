document.querySelectorAll('input[data-submit="true"]').forEach(function (el) {
  el.addEventListener('change', function () {
    if (this.defaultValue === '') {
      this.dataset['params'] = this.name + '=' + this.checked;
    } else if (this.checked) {
      this.dataset['params'] = this.name + '=' + this.defaultValue;
    }
  });
});
document.querySelectorAll('input[data-form="true"]').forEach(function (el) {
  el.addEventListener('change', function () {
    Rails.fire(this.form, 'submit');
  });
});

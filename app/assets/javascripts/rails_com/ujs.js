document.querySelectorAll('input[data-submit="true"]').forEach(function (el) {
  el.addEventListener('change', function () {
    if (this.defaultValue === '') {
      this.dataset['params'] = this.name + '=' + this.checked;
    } else {
      this.dataset['params'] = this.name + '=' + this.defaultValue;
    }
  });
});
document.querySelectorAll('input[data-form="true"]').forEach(function (el) {
  el.addEventListener('change', function () {
    Rails.fire(this.form, 'submit');
  });
});
document.querySelectorAll('input[data-filter="true"]').forEach(function (el) {
  el.addEventListener('change', function () {
    this.dataset['params'] = this.name + '=' + this.value;
  });
});

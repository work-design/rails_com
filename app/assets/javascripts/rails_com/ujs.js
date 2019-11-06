document.querySelectorAll('input[data-submit="true"], select[data-submit="true"]').forEach(function(el) {
  el.addEventListener('change', function () {
    if (this.dataset['params']) {
      this.dataset['params'] += '&'
    } else {
      this.dataset['params'] = ''
    }
    var str;
    if (this.defaultValue === '') {
      str = this.name + '=' + this.checked;
    } else {
      str = this.name + '=' + this.defaultValue;
    }
    this.dataset['params'] += str
  });
});

document.querySelectorAll('input[data-form="true"], select[data-form="true"]').forEach(function(el) {
  el.addEventListener('change', function () {
    Rails.fire(this.form, 'submit')
  })
})


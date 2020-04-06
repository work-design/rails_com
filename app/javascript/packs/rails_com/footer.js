document.querySelectorAll('input[data-submit="true"], select[data-submit="true"]').forEach(function(el) {
  el.addEventListener('change', function() {
    if (this.dataset['params']) {
      this.dataset['params'] += '&'
    } else {
      this.dataset['params'] = ''
    }
    let str
    if (this.defaultValue === '') {
      str = this.name + '=' + this.checked
    } else {
      str = this.name + '=' + this.defaultValue
    }
    this.dataset['params'] += str
  })
})

document.querySelectorAll('input[data-form="true"], select[data-form="true"]').forEach(function(el) {
  el.addEventListener('change', function() {
    Rails.fire(this.form, 'submit')
  })
})

document.querySelectorAll('form[method="get"]').forEach(function(el) {
  el.addEventListener('submit', function() {
    for (let i = 0; i < this.elements.length; i++) {
      if ( this[i].value.length === 0 ) {
        this[i].disabled = true
      }

      if ( this[i].name === 'commit' ) {
        this[i].disabled = true
      }
    }
  })
})

document.querySelectorAll('input[data-filter="true"], select[data-filter="true"]').forEach(function(el) {
  el.addEventListener('change', function () {
    let url = new URL(location)
    url.searchParams.set(this.name, this.value)

    Turbolinks.visit(url)
  })
})


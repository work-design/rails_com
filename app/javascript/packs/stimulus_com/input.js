import { Controller } from 'stimulus'

// data-controller="input"
class InputController extends Controller {

  connect() {
    console.log('Input Controller works!')
  }

  submit(event) {
    let el = event.target
    if (el.dataset['params']) {
      el.dataset['params'] += '&'
    } else {
      el.dataset['params'] = ''
    }
    let str
    if (el.defaultValue === '') {
      str = el.name + '=' + el.checked
    } else if (el.nodeName === 'SELECT') {
      str = el.name + '=' + el.value
    } else {
      str = el.name + '=' + el.defaultValue
    }
    el.dataset['params'] += str
  }

  form(event) {
    Rails.fire(event.target.form, 'submit')
  }

  filter(event) {
    let el = event.target
    let url = new URL(location)
    url.searchParams.set(el.name, el.value)

    Turbolinks.visit(url)
  }

}

application.register('input', InputController)

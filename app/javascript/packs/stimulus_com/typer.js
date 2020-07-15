import { Controller } from 'stimulus'

// data-controller="typer"
class TyperController extends Controller {

  connect() {
    console.debug('Typer Controller works!')
    let ele = this.element
    ele.addEventListener('input', this.form)
    ele.addEventListener('compositionstart', event => {
      event.target.removeEventListener('input', this.form)
    })
    ele.addEventListener('compositionend', event => {
      event.target.addEventListener('input', this.form)
      this.form(event)
    })
  }

  form(event) {
    let ele = event.currentTarget
    if (!ele.value) {
      return
    }

    let url = ele.dataset['url']
    if (url) {
      Rails.ajax({
        url: url,
        type: 'GET',
        data: `${ele.name}=${ele.value}`,
        dataType: 'script'
      })
    } else {
      Rails.fire(ele.form, 'submit')
    }
  }

}

application.register('typer', TyperController)

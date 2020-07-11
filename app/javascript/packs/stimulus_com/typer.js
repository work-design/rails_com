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
    if (event.currentTarget.value) {
      Rails.fire(event.target.form, 'submit')
    }
  }

}

application.register('typer', TyperController)

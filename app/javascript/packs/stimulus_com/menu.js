import { Controller } from 'stimulus'

// data-controller="menu"
class MenuController extends Controller {

  connect() {
    console.debug('Menu Controller works!')
  }

  toggle() {
    this.element.classList.toggle('is-active')
  }

}

application.register('menu', MenuController)

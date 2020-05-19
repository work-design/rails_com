import { Controller } from 'stimulus'

class NavbarController extends Controller {
  static targets = ['menu']

  connect() {
    console.log('Navbar Controller works!')
  }

  toggle(element) {
    element.currentTarget.classList.toggle('is-active')
    this.menuTarget.classList.toggle('is-active')
  }

}

application.register('navbar', NavbarController)

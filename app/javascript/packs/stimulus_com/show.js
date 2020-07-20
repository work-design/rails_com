import { Controller } from 'stimulus'

class ShowController extends Controller {
  static targets = ['src', 'item']

  connect() {
    console.debug('Show Controller works!')
  }

  show(element) {
    this.itemTargets.forEach(el => {
      el.style.visibility = 'visible'
    })
  }

  hide(element) {
    this.itemTargets.forEach(el => {
      el.style.visibility = 'hidden'
    })
  }

}

application.register('show', ShowController)

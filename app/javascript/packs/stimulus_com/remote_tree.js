import { Controller } from 'stimulus'

class RemoteTreeController extends Controller {

  connect() {
    console.debug('Remote Tree Controller works!')
  }

  collapse(event) {
    let ele = event.currentTarget
    let par = ele.parentNode.parentNode.parentNode
    ele.parentNode.addEventListener('click', this.disableLink)

    var el = par.nextElementSibling
    while (el && el.id.startsWith(par.id)) {
      el = el.nextElementSibling
      el.previousElementSibling.remove()
    }

    ele.classList.replace('fa-caret-down', 'fa-caret-right')
    ele.dataset['action'] = 'click->remote_tree#expand'
  }

  expand(event) {
    let ele = event.currentTarget
    ele.parentNode.removeEventListener('click', this.disableLink)

    ele.classList.replace('fa-caret-right', 'fa-caret-down')
    ele.dataset['action'] = 'click->remote_tree#collapse'
  }

  disableLink(event) {
    event.stopPropagation()
    event.preventDefault()

    return false
  }

}

application.register('remote_tree', RemoteTreeController)

import { Controller } from 'stimulus'

class RemoteTreeController extends Controller {

  connect() {
    console.debug('Remote Tree Controller works!')
  }

  collapse(element) {
    let ele = element.target
    let par = ele.parentNode.parentNode

    let el = par.nextElementSibling
    while (el && el.dataset['depth'] !== par.dataset['depth'] && par.dataset['depth'].endsWith(el.dataset['depth'])) {
      el.style.display = 'none'
      el = el.nextElementSibling
    }

    ele.classList.replace('fa-caret-down', 'fa-caret-right')
    ele.dataset['action'] = 'click->tree#expand'
  }

  expand(element) {
    let ele = element.currentTarget
    let par = ele.parentNode.parentNode

    let el = par.nextElementSibling
    while (el && el.dataset['depth'] !== par.dataset['depth'] && par.dataset['depth'].endsWith(el.dataset['depth'])) {
      el.style.display = 'table-row'
      el = el.nextElementSibling
    }

    ele.classList.replace('fa-caret-right', 'fa-caret-down')
    ele.dataset['action'] = 'click->tree#collapse'
  }

}

application.register('remote_tree', RemoteTreeController)

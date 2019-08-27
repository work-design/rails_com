import { Controller } from 'stimulus'

// 2. data-controller="check"
class CheckController extends Controller {
  static targets = ['added', 'moved']

  connect() {
    console.log('Check Controller works!')
  }

  // data-action="check#toggle"
  toggle(event) {
    let checkbox = event.target
    let changed = checkbox.checked === checkbox.defaultChecked
    if (changed && checkbox.checked) {
      checkbox.dataset.add_target('check.added')
    } else if (changed && !checkbox.checked) {
      checkbox.dataset.add_target('check.moved')
    }
  }

  addedIds() {
    this.addedTargets
  }

  movedIds() {
    this.movedTargets
  }

  // data-action="check#toggleAll"
  // data-check-name="xx"
  toggleAll(event) {
    let element = event.target
    let checkboxes = document.getElementsByName(this.data.get('name'));
    
    for (let checkbox of checkboxes) {
      checkbox.checked = element.checked
      let changed = checkbox.checked === checkbox.defaultChecked
      if (changed && checkbox.checked) {
        checkbox.dataset.add_target('check.added')
      } else if (changed && !checkbox.checked) {
        checkbox.dataset.add_target('check.moved')
      }
    }
  }
}

application.register('check', CheckController)

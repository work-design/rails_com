import { Controller } from 'stimulus'

// 1. add an form
// 2. form data-controller="check"
class CheckController extends Controller {
  static targets = ['added', 'moved']

  connect() {
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
  toggleAll(event) {
    let element = event.target
    let checkboxes = document.getElementsByName(name);

    for (checkbox of checkboxes) {
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

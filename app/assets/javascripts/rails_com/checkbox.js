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
    let changed = checkbox.checked !== checkbox.defaultChecked
    this.doToggle(checkbox, changed)
  }

  addedIds() {
    let ids = []
    this.addedTargets.forEach((item) => {
      ids.push(item.value)
    })
    return ids
  }

  movedIds() {
    let ids = []
    this.movedTargets.forEach((item) => {
      ids.push(item.value)
    })
    return ids
  }

  // data-action="check#toggleAll"
  // data-check-name="xx"
  toggleAll(event) {
    let element = event.target
    let checkboxes = document.getElementsByName(this.data.get('name'));

    for (let checkbox of checkboxes) {
      checkbox.checked = element.checked
      let changed = checkbox.checked !== checkbox.defaultChecked
      this.doToggle(checkbox, changed)
    }
  }

  doToggle(checkbox, changed) {
    if (changed && checkbox.checked) {
      checkbox.dataset.add_target('check.added')
    } else if (changed && !checkbox.checked) {
      checkbox.dataset.add_target('check.moved')
    } else {
      checkbox.dataset.remove_target('check.added')
      checkbox.dataset.remove_target('check.moved')
    }
  }
}

application.register('check', CheckController)

import { Controller } from 'stimulus'

// data-controller="check"
// data-check-name="xx"
class CheckController extends Controller {
  static targets = ['added', 'moved']

  connect() {
    console.log('Check Controller works!')
  }

  applyFor(event) {
    let link = event.currentTarget
    let url = new URL(link.href)
    let added = this.addedIds()
    let moved = this.movedIds()
    if (added.length > 0) {
      url.searchParams.set('add_ids', added)
    }
    if (moved.length > 0) {
      url.searchParams.set('remove_ids', added)
    }

    link.href = url
  }

  addedIds() {
    let ids = []
    this.addedTargets.forEach((item) => {
      ids.push(item.value)
    })
    return ids.join(',')
  }

  movedIds() {
    let ids = []
    this.movedTargets.forEach((item) => {
      ids.push(item.value)
    })
    return ids.join(',')
  }

  // data-action="check#toggle"
  toggle(event) {
    let checkbox = event.currentTarget
    let changed = checkbox.checked !== checkbox.defaultChecked
    this.doToggle(checkbox, changed)
  }

  // data-action="check#toggleAll"
  toggleAll(event) {
    let element = event.currentTarget
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

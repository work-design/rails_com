import { Controller } from 'stimulus'

class SearchController extends Controller {
  static targets = ['input', 'label']

  connect() {
    console.log('Search Controller works!')
  }

  cancelSearch() {
    hideSearchResult()

  }

  focus() {
    this.element.classList.add('weui-search-bar_focusing')
    this.inputTarget.focus()
  }

  doSearch(element) {
    let ele = element.currentTarget
    if(ele.value.length) {
      alert(ele.value)
    }
  }

  hide(element) {
    let ele = element.currentTarget
    this.inputTarget.value = ''
    this.inputTarget.focus()
  }

  cancel() {
    this.element.classList.remove('weui-search-bar_focusing')
    this.labelTarget.show()
    this.inputTarget.blur()
  }

}

application.register('search', SearchController)

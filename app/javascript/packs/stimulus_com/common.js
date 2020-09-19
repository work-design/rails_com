import { Controller } from 'stimulus'

// data-controller="common"
class CommonController extends Controller {

  connect() {
    console.debug('Common Controller works!')
  }

  cancel() {
    Turbolinks.clearCache()
    Turbolinks.visit(location.href, { action: 'replace' })
  }

}

application.register('common', CommonController)

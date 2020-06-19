import { Controller } from 'stimulus'
import Choices from 'choices.js'

class ChoiceController extends Controller {

  reload(element) {
    new Choices(element, {
      noChoicesText: '无可选项'
    })
  }

  connect() {
    console.log('Choice Controller works!')
    this.reload(this.element)
  }

}

application.register('choice', ChoiceController)

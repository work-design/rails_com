//= require input-attachment

class InputController extends Stimulus.Controller {
  greet() {
    console.log('Hellos, Stimulus!', this.element)
  }

  connect() {
    console.log('Connects, Stimulus!', this.element)
    var self = this;
    attachToPreview({
      fileInput: 'picture_file'
    });
  }
}
InputController.targets = ['src']
const application = Stimulus.Application.start()
application.register('attachment', InputController)

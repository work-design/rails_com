import { attachToPreview } from './attachment'
import { Application } from 'stimulus'

class PictureController extends Stimulus.Controller {
  greet() {
    console.log('Hellos, Stimulus!', this.element)
  }

  connect() {
    console.log('Connects, Stimulus!', this.element)
    attachToPreview({
      fileInput: 'picture_file'
    });
  }
}
PictureController.targets = ['src']
const application = Stimulus.Application.start()
application.register('picture', PictureController)

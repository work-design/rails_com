import InputAttachment from './attachment'
import { Controller } from 'stimulus'

class PictureController extends Controller {
  static targets = ['src']

  connect() {
    let input = this.element
    var fileInput = document.getElementById(options['fileInput']);
    options['editor'] = input;
    options['fileInput'] = fileInput;
    var inlineAttach = new InputAttachment(options);

    input.addEventListener('paste', function(e) {
      inlineAttach.onPaste(e);
    }, false);

    input.addEventListener('drop', function(e) {
      e.stopPropagation();
      e.preventDefault();
      inlineAttach.onDrop(e);
    }, false);

    input.addEventListener('dragenter', function(e) {
      e.stopPropagation();
      e.preventDefault();
    }, false);

    input.addEventListener('dragover', function(e) {
      e.stopPropagation();
      e.preventDefault();
    }, false);

    if (fileInput) {
      fileInput.addEventListener('click', function(e) {
        inlineAttach.onFileInputClick(e)
      }, false);

      fileInput.addEventListener('change', function(e) {
        inlineAttach.onFileInputChange(e)
      }, false);
    }
  }

  preview() {
    var fileInput = document.getElementById(options['fileInput']);
    options['fileInput'] = fileInput;
    var inlineAttach = new InputAttachment(options);

    if (fileInput) {
      fileInput.addEventListener('change', function(e) {
        inlineAttach.imagePreview(e, options['previewDiv'])
      }, false);
    }
  }

}

application.register('picture', PictureController)

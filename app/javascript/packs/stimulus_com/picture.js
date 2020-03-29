import InputAttachment from 'rails_com/attachment'
import { Controller } from 'stimulus'

// <input type="file" data-controller="picture">
class PictureController extends Controller {
  static targets = ['src', 'previewDiv']

  connect() {

  }

  /*
  * <input type="file" data-action="picture#upload">
  **/
  upload() {
    let input = this.element
    let options = {}
    options['editor'] = input;
    options['fileInput'] = fileInput;
    let fileInput = document.getElementById(options['fileInput']);
    let inlineAttach = new InputAttachment(options);
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

  previewFile(file, previewDiv) {
    let fileList = document.getElementById(this.previewDivTarget);
    let templateDiv = document.getElementById(this.settings.templateDiv);
    let template = document.createElement('template');
    fileList.querySelectorAll('[data-preview=true]').forEach(e => e.parentNode.removeChild(e));
    template.innerHTML = templateDiv.outerHTML.trim();
    var img_div = template.content.firstChild;
    img_div.style.display = 'inline-block';
    img_div.dataset['preview'] = true;
    img_div.id = null;
    var img = img_div.lastElementChild;

    img.src = window.URL.createObjectURL(file); //创建一个object URL，并不是你的本地路径
    img.onload = function(e) {
      window.URL.revokeObjectURL(this.src); //图片加载后，释放object URL
    };

    fileList.appendChild(img_div);
  };


}

application.register('picture', PictureController)

import InputAttachment from 'rails_com/attachment'
import { DirectUpload } from '@rails/activestorage/src/direct_upload'
import { start } from '@rails/activestorage/src/ujs'
import { DirectUploadController } from '@rails/activestorage/src/direct_upload_controller'
import { Controller } from 'stimulus'

// <input type="file" data-controller="picture">
class PictureController extends Controller {
  static targets = ['src', 'filename', 'preview']

  connect() {
    console.log('Picture Controller works!')
  }

  /*
  * <input type="file" data-action="picture#upload">
  **/
  upload(event) {
    let input = event.currentTarget
    Array.from(input.files).forEach(file => {
      this.filenameTarget.innerText = file.name
      // todo file is image
      this.previewFile(file)
      let controller = new DirectUploadController(input, file)
      if (controller) {
        controller.start(error => {
          if (error) {
            callback(error)
            this.dispatch('end')
          }
        })
      }
    })
  }

  xxx(event) {
    alert('ddd')
  }

  dropFile(event) {
    alert('drop')
    event.preventDefault()
    event.stopPropagation()
    for (var i = 0; i < event.dataTransfer.files.length; i++) {
      var file = e.dataTransfer.files[i]
      console.log(file.name)
    }
  }

  pasteFile(event) {
    alert('xxx')
    var result = false,
      clipboardData = event.clipboardData,
      items;

    if (typeof clipboardData === 'object') {
      items = clipboardData.items || clipboardData.files || []

      for (var i = 0; i < items.length; i++) {
        var item = items[i]
        console.log(item)
      }
    }

    if (result) { event.preventDefault(); }

    return result;
  };

  previewFile(file) {
    let template = this.previewTarget
    let cloned = template.cloneNode(true)
    cloned.style.display = 'block'

    let img = cloned.querySelector('img')
    img.src = window.URL.createObjectURL(file) //创建一个object URL，并不是你的本地路径
    img.onload = function(e) {
      console.log(e)
      window.URL.revokeObjectURL(img.src) //图片加载后，释放object URL
    }

    template.after(cloned)
  }

}

application.register('picture', PictureController)

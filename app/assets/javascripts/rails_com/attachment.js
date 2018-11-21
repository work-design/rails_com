/* jslint newcap: true */
/* global XMLHttpRequest: false, FormData: false */

/*
* Input Field with Attachment
* based on https://github.com/Rovak/inlineAttachment/blob/master/LICENSE
*/

(function(document, window) {
  'use strict';

  var InputAttachment = function(options) {
    this.settings = Object.assign(InputAttachment.defaults, options);
    this.editor = this.settings['editor'];
    this.filenameTag = '{filename}';
    this.lastValue = null;
  };

  /**
   * Default configuration options
   *
   * @type {Object}
   */
  InputAttachment.defaults = {
    /**
     * URL where the file will be send
     */
    uploadUrl: 'upload_attachment.php',

    /**
     * Which method will be used to send the file to the upload URL
     */
    uploadMethod: 'POST',

    /**
     * Name in which the file will be placed
     */
    uploadFieldName: 'file',

    uploadFileInput: '',

    templateDiv: 'file_template',

    /**
     * Extension which will be used when a file extension could not
     * be detected
     */
    defaultExtension: 'png',

    /**
     * JSON field which refers to the uploaded file URL
     */
    jsonFieldName: 'filename',

    /**
     * Allowed MIME types
     */
    allowedTypes: [
      'image/jpeg',
      'image/png',
      'image/jpg',
      'image/gif'
    ],

    /**
     * Text which will be inserted when dropping or pasting a file.
     * Acts as a placeholder which will be replaced when the file is done with uploading
     */
    progressText: '![Uploading file...]()',

    /**
     * When a file has successfully been uploaded the progressText
     * will be replaced by the urlText, the {filename} tag will be replaced
     * by the filename that has been returned by the server
     */
    urlText: "![file]({filename})",

    /**
     * Text which will be used when uploading has failed
     */
    errorText: 'Error uploading file',

    /**
     * Extra parameters which will be send when uploading a file
     */
    extraParams: {},

    /**
     * Extra headers which will be send when uploading a file
     */
    extraHeaders: {},

    /**
     * Before the file is send
     */
    beforeFileUpload: function() {
      return true;
    },

    /**
     * Triggers when a file is dropped or pasted
     */
    onFileReceived: function() {

    },

    /**
     * Custom upload handler
     *
     * @return {Boolean} when false is returned it will prevent default upload behavior
     */
    onFileUploadResponse: function() {
      return true;
    },

    /**
     * Custom error handler. Runs after removing the placeholder text and before the alert().
     * Return false from this function to prevent the alert dialog.
     *
     * @return {Boolean} when false is returned it will prevent default error behavior
     */
    onFileUploadError: function() {
      return true;
    },

    /**
     * When a file has successfully been uploaded
     */
    onFileUploaded: function() {}
  };

  /**
   * Uploads the blob
   *
   * @param  {Blob} file blob data received from event.dataTransfer object
   * @return {XMLHttpRequest} request object which sends the file
   */
  InputAttachment.prototype.uploadFile = function(file) {
    var me = this,
      formData = new FormData(),
      xhr = new XMLHttpRequest(),
      settings = this.settings,
      extension = settings.defaultExtension || settings.defualtExtension;

    if (typeof settings.setupFormData === 'function') {
      settings.setupFormData(formData, file);
    }

    // Attach the file. If coming from clipboard, add a default filename (only works in Chrome for now)
    // http://stackoverflow.com/questions/6664967/how-to-give-a-blob-uploaded-as-formdata-a-file-name
    if (file.name) {
      var fileNameMatches = file.name.match(/\.(.+)$/);
      if (fileNameMatches) {
        extension = fileNameMatches[1];
      }
    }

    var remoteFilename = 'image-' + Date.now() + '.' + extension;
    if (typeof settings.remoteFilename === 'function') {
      remoteFilename = settings.remoteFilename(file);
    }

    formData.append(settings.uploadFieldName, file, remoteFilename);

    // Append the extra parameters to the form data
    if (typeof settings.extraParams === 'object') {
      for (var key in settings.extraParams) {
        if (settings.extraParams.hasOwnProperty(key)) {
          formData.append(key, settings.extraParams[key]);
        }
      }
    }

    xhr.open('POST', settings.uploadUrl);

    // Add any available extra headers
    if (typeof settings.extraHeaders === 'object') {
        for (var header in settings.extraHeaders) {
            if (settings.extraHeaders.hasOwnProperty(header)) {
                xhr.setRequestHeader(header, settings.extraHeaders[header]);
            }
        }
    }

    xhr.onload = function() {
      // If HTTP status is OK or Created
      if (xhr.status === 200 || xhr.status === 201) {
        me.onFileUploadResponse(xhr);
      } else {
        me.onFileUploadError(xhr);
      }
    };
    if (settings.beforeFileUpload(xhr) !== false) {
      xhr.send(formData);
    }
    return xhr;
  };

  InputAttachment.prototype.previewFile = function(file, previewDiv) {
    var fileList = document.getElementById(previewDiv);
    var templateDiv = document.getElementById(this.settings.templateDiv);
    var template = document.createElement('template');
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

  /**
   * Returns if the given file is allowed to handle
   *
   * @param {File} file clipboard data file
   */
  InputAttachment.prototype.isFileAllowed = function(file) {
    if (file.kind === 'string') { return false; }
    if (this.settings.allowedTypes.indexOf('*') === 0){
      return true;
    } else {
      return this.settings.allowedTypes.indexOf(file.type) >= 0;
    }
  };

  /**
   * Handles upload response
   *
   * @param  {XMLHttpRequest} xhr
   * @return {void}
   */
  InputAttachment.prototype.onFileUploadResponse = function(xhr) {
    if (this.settings.onFileUploadResponse.call(this, xhr) !== false) {
      var result = JSON.parse(xhr.responseText),
        filename = result[this.settings.jsonFieldName];

      if (result && filename) {
        var newValue;
        if (typeof this.settings.urlText === 'function') {
          newValue = this.settings.urlText.call(this, filename, result);
        } else {
          newValue = this.settings.urlText.replace(this.filenameTag, filename);
        }
        this.editor.value.replace(this.lastValue, newValue);
        this.settings.onFileUploaded.call(this, filename, result);
      }
    }
  };


  /**
   * Called when a file has failed to upload
   *
   * @param  {XMLHttpRequest} xhr
   * @return {void}
   */
  InputAttachment.prototype.onFileUploadError = function(xhr) {
    if (this.settings.onFileUploadError.call(this, xhr) !== false) {
      this.editor.value.replace(this.lastValue, '');
    }
  };

  /**
   * Called when a file has been inserted, either by drop or paste
   *
   * @param  {File} file
   * @return {void}
   */
  InputAttachment.prototype.onFileInserted = function(file) {
    if (this.settings.onFileReceived.call(this, file) !== false) {
      this.lastValue = this.settings.progressText;

      var scrollPos = el.scrollTop;
      el.value = this.lastValue;
      el.scrollTop = scrollPos;
    }
  };

  /**
   * Called when a paste event occurred
   * @param  {Event} e
   * @return {Boolean} if the event was handled
   */
  InputAttachment.prototype.onPaste = function(e) {
    var result = false,
      clipboardData = e.clipboardData,
      items;

    if (typeof clipboardData === 'object') {
      items = clipboardData.items || clipboardData.files || [];

      for (var i = 0; i < items.length; i++) {
        var item = items[i];
        if (this.isFileAllowed(item)) {
          result = true;
          this.onFileInserted(item.getAsFile());
          this.uploadFile(item.getAsFile());
        }
      }
    }

    if (result) { e.preventDefault(); }

    return result;
  };

  /**
   * Called when a drop event occurs
   * @param  {Event} e
   * @return {Boolean} if the event was handled
   */
  InputAttachment.prototype.onDrop = function(e) {
    var result = false;
    for (var i = 0; i < e.dataTransfer.files.length; i++) {
      var file = e.dataTransfer.files[i];
      if (this.isFileAllowed(file)) {
        result = true;
        this.onFileInserted(file);
        this.uploadFile(file);
      }
    }

    return result;
  };

  InputAttachment.prototype.onFileInputChange = function(e) {
    var result = false;
    for (var i = 0; i < e.target.files.length; i++) {
      var file = e.target.files[i];
      if (this.isFileAllowed(file)) {
        result = true;
        this.uploadFile(file);
      }
    }

    return result;
  };

  InputAttachment.prototype.imagePreview = function(e, previewDiv){
    var result = false;

    for (var i = 0; i < e.target.files.length; i++) {
      var file = e.target.files[i];
      if (this.isFileAllowed(file)) {
        result = true;
        this.previewFile(file, previewDiv);
      }
    }

    return result;
  };

  InputAttachment.prototype.onFileInputClick = function(e) {
    console.log('fileInputClick', e)
  };

  window.InputAttachment = InputAttachment;

  function attachToInput(options) {
    options = options || {};
    var input = document.getElementById(options['input']);
    var fileInput = document.getElementById(options['fileInput']);
    options['editor'] = input;
    options['fileInput'] = fileInput;
    var inlineAttach = new InputAttachment(options);

    if (input) {
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
    }
    if (fileInput) {
      fileInput.addEventListener('click', function(e) {
        inlineAttach.onFileInputClick(e)
      }, false);

      fileInput.addEventListener('change', function(e) {
        inlineAttach.onFileInputChange(e)
      }, false);
    }
  }

  function attachToPreview(options) {
    options = options || {};
    var fileInput = document.getElementById(options['fileInput']);
    options['fileInput'] = fileInput;
    var inlineAttach = new InputAttachment(options);

    if (fileInput) {
      fileInput.addEventListener('change', function(e) {
        inlineAttach.imagePreview(e, options['previewDiv'])
      }, false);
    }
  }

  window.attachToInput = attachToInput;
  window.attachToPreview = attachToPreview;
})(document, window);

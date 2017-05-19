/*jslint newcap: true */
/*global inlineAttachment: false */
// require input fileInput
//
(function() {
  'use strict';
  console.log('----------------------------------------')

  function attachToInput(options) {
    options = options || {};
    var input = document.getElementById(options['input']);
    var fileInput = document.getElementById(options['fileInput']);

    var inlineattach = new InputAttachment(options);
    if (input) {
      input.addEventListener('paste', function (e) {
        inlineattach.onPaste(e);
      }, false);

      input.addEventListener('drop', function (e) {
        e.stopPropagation();
        e.preventDefault();
        inlineattach.onDrop(e);
      }, false);

      input.addEventListener('dragenter', function (e) {
        e.stopPropagation();
        e.preventDefault();
      }, false);

      input.addEventListener('dragover', function (e) {
        e.stopPropagation();
        e.preventDefault();
      }, false);
    }
    fileInput.addEventListener('click', function(e) {
      inlineattach.onFileInputClick(e)
    }, false);

    fileInput.addEventListener('change', function(e) {
      inlineattach.onFileInputChange(e)
    }, false);
  }

  window.attachToInput = attachToInput;

})();
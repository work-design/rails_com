import ujs from '@rails/ujs'
import turbolinks from 'turbolinks'

ujs.start()
turbolinks.start()

function remote_js_load(paths) {
  if (Array.isArray(paths)) {
    for (i = 0; i < paths.length; i++) {
      Rails.ajax({url: paths[i], type: 'GET', dataType: 'script'})
    }
  } else if (typeof(paths) === 'string') {
    Rails.ajax({url: paths, type: 'GET', dataType: 'script'})
  }
}

function timeForLocalized() {
  document.querySelectorAll('time:not([data-localized="true"])').forEach(function(el) {
    if (el.textContent.length > 0) {
      var format = el.dataset['format'] || 'YYYY-MM-DD HH:mm';
      el.textContent = moment.utc(el.textContent).local().format(format);
      el.dataset['localized'] = 'true'
    }
  })
}

document.addEventListener('DOMContentLoaded', function() {
  timeForLocalized()
});
document.addEventListener('turbolinks:load', function() {
  timeForLocalized()
});
document.addEventListener('turbolinks:visit', function() {
  timeForLocalized()
});
document.addEventListener('ajax:success', function() {
  timeForLocalized()
});

document.addEventListener('ajax:beforeSend', function(event) {
  var detail = event.detail;
  var xhr = detail[0];
  var offset = (new Date).getTimezoneOffset();
  xhr.setRequestHeader('Utc-Offset', offset);
  xhr.setRequestHeader('X-Csp-Nonce', Rails.cspNonce())
});
document.addEventListener('turbolinks:request-start', function(event) {
  var xhr = event.data.xhr;
  var offset = (new Date).getTimezoneOffset();
  xhr.setRequestHeader('Utc-Offset', offset);
  xhr.setRequestHeader('X-Csp-Nonce', Rails.cspNonce())
});

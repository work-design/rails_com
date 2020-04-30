import Rails from '@rails/ujs'
import Turbolinks from '@qinmingyuan/turbolinks'
import 'rails_com/package/remote_js_load'

Rails.start()
Turbolinks.start()

const timeForLocalized = () => {
  document.querySelectorAll('time:not([data-localized="true"])').forEach(function(el) {
    if (el.textContent.length > 0) {
      var format = el.dataset['format'] || 'YYYY-MM-DD HH:mm'
      el.textContent = moment.utc(el.textContent).local().format(format)
      el.dataset['localized'] = 'true'
    }
  })
}

document.addEventListener('DOMContentLoaded', function() {
  timeForLocalized()
})
document.addEventListener('turbolinks:load', function() {
  timeForLocalized()
})
document.addEventListener('turbolinks:visit', function() {
  timeForLocalized()
})
document.addEventListener('ajax:success', function() {
  timeForLocalized()
})

document.addEventListener('ajax:beforeSend', function(event) {
  let detail = event.detail
  let xhr = detail[0]
  let offset = (new Date).getTimezoneOffset()
  xhr.setRequestHeader('Utc-Offset', offset)
  xhr.setRequestHeader('X-Csp-Nonce', Rails.cspNonce())
})
document.addEventListener('turbolinks:request-start', function(event) {
  let xhr = event.data.xhr
  let offset = (new Date).getTimezoneOffset()
  xhr.setRequestHeader('Utc-Offset', offset)
  xhr.setRequestHeader('X-Csp-Nonce', Rails.cspNonce())
})

document.addEventListener('ajax:beforeSend', event => {
  let xhr = event.detail[0]
  xhr.setRequestHeader('Utc-Offset', (new Date).getTimezoneOffset())
  xhr.setRequestHeader('X-Csp-Nonce', Rails.cspNonce())
})

document.addEventListener('turbolinks:request-start', event => {
  let xhr = event.data.xhr
  xhr.setRequestHeader('Utc-Offset', (new Date).getTimezoneOffset())
  xhr.setRequestHeader('X-Csp-Nonce', Rails.cspNonce())
})

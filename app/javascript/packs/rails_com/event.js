document.addEventListener('ajax:beforeSend', event => {
  let xhr = event.detail[0]
  xhr.setRequestHeader('Utc-Offset', (new Date).getTimezoneOffset())
  xhr.setRequestHeader('X-Csp-Nonce', Rails.cspNonce())
})

document.addEventListener('turbo:before-fetch-request', event => {
  xhr = event.detail.fetchOptions
  xhr.headers['Utc-Offset'] = (new Date).getTimezoneOffset()
  xhr.headers['X-Csp-Nonce'] = Rails.cspNonce()
})

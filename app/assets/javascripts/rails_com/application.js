//= require rails-ujs
//= require turbolinks
//= require ./time_local
//= require_self

function clickCallback(e) {
  if (e.target.tagName !== 'A') {
    return;
  }
  (new Date).getTimezoneOffset();
}
//document.addEventListener('click', clickCallback, false);

function htmlToElement(html_str) {
  var template = document.createElement('template');
  template.innerHTML = html_str.trim();
  return template.content.firstChild;
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

document.addEventListener('turbolinks:request-start', function(event) {
  var xhr = event.data.xhr;
  var offset = (new Date).getTimezoneOffset();
  xhr.setRequestHeader('Utc-Offset', offset);
  xhr.setRequestHeader('X-Csp-Nonce', Rails.cspNonce())
});
document.addEventListener('ajax:beforeSend', function(event) {
  var detail = event.detail;
  var xhr = detail[0];
  xhr.setRequestHeader('X-Csp-Nonce', Rails.cspNonce())
});

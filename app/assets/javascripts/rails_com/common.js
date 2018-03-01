function timeForLocalized(){
  $('time[data-localized!="true"]').each(function(){
    this.textContent = moment.utc(this.textContent).local().format('YYYY-MM-DD HH:mm:ss');
    this.dataset['localized'] = 'true'
  })
}

function clickCallback(e) {
  if (e.target.tagName !== 'A') {
    return;
  }
  (new Date).getTimezoneOffset();
}

//document.addEventListener('click', clickCallback, false);

document.addEventListener('DOMContentLoaded', function() {
  timeForLocalized()
});

document.addEventListener('turbolinks:load', function() {
  timeForLocalized()
});

document.addEventListener('turbolinks:request-start', function(event) {
  var xhr = event.data.xhr;
  var offset = (new Date).getTimezoneOffset();
  xhr.setRequestHeader('Utc-Offset', offset);
});




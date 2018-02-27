function timeForLocalized(){
  $('time[data-localized!="true"]').each(function(){
    this.textContent = moment.utc(this.textContent).local().format('YYYY-MM-DD HH:mm:ss');
    this.dataset['localized'] = 'true'
  })
}

document.addEventListener('DOMContentLoaded', function(){
  timeForLocalized()
});

document.addEventListener('turbolinks:load', function(){
  timeForLocalized()
});
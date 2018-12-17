function timeForLocalized(){
  $('time[data-localized!="true"]').each(function(){
    if (this.textContent.length > 0) {
      var format = this.dataset['format'] || 'YYYY-MM-DD HH:mm:ss';
      this.textContent = moment.utc(this.textContent).local().format(format);
      this.dataset['localized'] = 'true'
    }
  })
}

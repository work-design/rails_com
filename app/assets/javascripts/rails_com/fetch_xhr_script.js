function fetch_xhr_script(url, params){
  let default_params = {
    credentials: 'include',
    headers: {
      'Accept': 'application/javascript',
      'X-CSRF-Token': document.head.querySelector("[name=csrf-token]").content
    }
  };

  fetch(url, params).then(function(response) {
    return response.text()
  }).then(function(text) {
    let script = document.createElement('script');
    script.text = text;
    document.head.appendChild(script).parentNode.removeChild(script);
  }).catch(function(ex) {
    console.log('parsing failed', ex)
  })
}
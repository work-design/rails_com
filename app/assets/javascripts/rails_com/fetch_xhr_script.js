function fetch_xhr_script(url, params){
  var default_params = {
    credentials: 'include',
    headers: {
      Accept: 'application/javascript',
      'X-CSRF-Token': document.head.querySelector("[name=csrf-token]").content
    }
  };
  var _params = Object.assign(default_params, params);

  fetch(url, _params).then(function(response) {
    return response.text();
  }).then(function(text) {
    var script = document.createElement('script');
    script.setAttribute('nonce', Rails.cspNonce());
    script.text = text;
    document.head.appendChild(script).parentNode.removeChild(script);
  }).catch(function(ex) {
    console.log('parsing failed', ex);
  })
}

function remote_js_load(paths) {
  for (i = 0; i < paths.length; i++) {
    Rails.ajax({
      url: paths[i],
      type: 'GET',
      dataType: 'script'
    })
  }
}

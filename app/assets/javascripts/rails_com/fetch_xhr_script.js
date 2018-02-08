function fetch_xhr_script(url, params){
  fetch(url, params).then(function(response) {
    return response.text()
  }).then(function(text) {
    var script = document.createElement('script');
    script.text = text;
    document.head.appendChild(script).parentNode.removeChild(script);
  }).catch(function(ex) {
    console.log('parsing failed', ex)
  })
};

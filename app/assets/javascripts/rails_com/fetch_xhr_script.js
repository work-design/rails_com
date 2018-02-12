function fetch_xhr_script(url, params){
  var default_params = {
    credentials: 'include',
    headers: {
      'Accept': 'application/javascript',
      'X-CSRF-Token': document.head.querySelector("[name=csrf-token]").content
    }
  };

  fetch(url, params).then(function(response) {
    return response.text()
  }).then(function(text) {
    var script = document.createElement('script');
    script.text = text;
    document.head.appendChild(script).parentNode.removeChild(script);
  }).catch(function(ex) {
    console.log('parsing failed', ex)
  })
}

function listenCheckedIds(name) {
  var checked = 'input[name="' + name + '"]:checked';
  var unchecked = 'input[name="' + name + '"][checked!="checked"]';

  window.add_ids = [];
  window.remove_ids = [];
  $(checked).change(function(){
    if(this.checked){
      var index = window.remove_ids.indexOf(this.value);
      window.remove_ids.splice(index, 1);
    } else {
      window.remove_ids.push(this.value)
    }
  });
  $(unchecked).change(function(){
    if(this.checked){
      window.add_ids.push(this.value)
    } else {
      var index = window.add_ids.indexOf(this.value);
      window.add_ids.splice(index, 1);
    }
  });
}

function getAddIds(){
  add_str = window.add_ids.join(',');
  return add_str;
}

function getRemoveIds(){
  remove_str = window.remove_ids.join(',');
  return remove_str
}

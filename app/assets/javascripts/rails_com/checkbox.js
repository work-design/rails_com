function listenCheckedIds(name) {
  var checked = 'input[name=' + name + ']';
  var add_ids = [];
  var remove_ids = [];
  var index;
  window.sessionStorage.setItem(name + '_add_ids', []);
  window.sessionStorage.setItem(name + '_remove_ids', []);

  $(checked).change(function(){
    if (this.checked && this.checked !== this.defaultChecked) {
      add_ids.push(this.value)
    } else if (this.checked && this.checked === this.defaultChecked) {
      index = remove_ids.indexOf(this.value);
      remove_ids.splice(index, 1);
    } else if (!this.checked && this.checked !== this.defaultChecked) {
      remove_ids.push(this.value)
    }  else if (!this.checked && this.checked === this.defaultChecked) {
      index = add_ids.indexOf(this.value);
      add_ids.splice(index, 1);
    }
    window.sessionStorage.setItem(name + '_remove_ids', remove_ids);
    window.sessionStorage.setItem(name + '_add_ids', add_ids);
  })
}

function getAddIds(name){
  add_str = window.sessionStorage.getItem(name + '_add_ids');
  return add_str;
}

function getRemoveIds(name){
  remove_str = window.sessionStorage.getItem(name + '_remove_ids');
  return remove_str
}

function toggleAll(source, name) {
  var checkboxes = document.getElementsByName(name);
  var add_ids = [];
  var remove_ids = [];
  var index;

  for(checkbox of checkboxes) {
    checkbox.checked = source.checked;
    if (checkbox.checked && checkbox.checked !== checkbox.defaultChecked) {
      add_ids.push(checkbox.value)
    } else if (checkbox.checked && checkbox.checked === checkbox.defaultChecked) {
      index = remove_ids.indexOf(checkbox.value);
      remove_ids.splice(index, 1);
    } else if (!checkbox.checked && checkbox.checked !== checkbox.defaultChecked) {
      remove_ids.push(checkbox.value)
    }  else if (!checkbox.checked && checkbox.checked === checkbox.defaultChecked) {
      index = add_ids.indexOf(checkbox.value);
      add_ids.splice(index, 1);
    }
  }

  window.sessionStorage.setItem(name + '_remove_ids', remove_ids);
  window.sessionStorage.setItem(name + '_add_ids', add_ids);
}

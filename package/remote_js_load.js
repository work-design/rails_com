import Rails from '@rails/ujs'

export default function remote_js_load(paths) {
  if (Array.isArray(paths)) {
    for (let i = 0; i < paths.length; i++) {
      Rails.ajax({url: paths[i], type: 'GET', dataType: 'script'})
    }
  } else if (typeof(paths) === 'string' && paths.length > 0) {
    Rails.ajax({url: paths, type: 'GET', dataType: 'script'})
  }
}

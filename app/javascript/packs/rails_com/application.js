import Rails from '@rails/ujs'
import Turbolinks from 'qinmingyuan_turbolinks'
import 'rails_com/package/remote_js_load'
import './event'
import { timeForLocalized, prepareFormFilter } from './footer'
import { prepareFormValid } from 'default_form/footer'

Rails.start()
Turbolinks.start()

document.addEventListener('DOMContentLoaded', function() {
  timeForLocalized()
  prepareFormFilter()
  prepareFormValid()
})
document.addEventListener('turbolinks:load', function() {
  timeForLocalized()
  prepareFormFilter()
  prepareFormValid()
})
document.addEventListener('turbolinks:visit', function() {
  timeForLocalized()
})
document.addEventListener('ajax:success', function() {
  timeForLocalized()
  prepareFormValid()
})

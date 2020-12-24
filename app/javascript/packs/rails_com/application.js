import Turbo from '@hotwired/turbo'
import './event'
import { timeForLocalized, prepareFormFilter } from './footer'
import { prepareFormValid } from 'default_form/footer'

document.addEventListener('DOMContentLoaded', function() {
  timeForLocalized()
  prepareFormFilter()
  prepareFormValid()
})
document.addEventListener('turbo:load', function() {
  timeForLocalized()
  prepareFormFilter()
  prepareFormValid()
})
document.addEventListener('turbo:visit', function() {
  timeForLocalized()
})
document.addEventListener('ajax:success', function() {
  timeForLocalized()
  prepareFormValid()
})

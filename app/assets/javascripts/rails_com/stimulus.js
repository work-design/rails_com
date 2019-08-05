//= require stimulus

window.application = Stimulus.Application.start();

DOMStringMap.prototype.add_controller = function(controller_name) {
  if (typeof this.controller === 'string' && this.controller.length > 0) {
    this.controller = this.controller.concat(' ').concat(controller_name)
  } else {
    this.controller = controller_name
  }
};

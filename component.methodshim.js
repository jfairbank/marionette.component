(function(Marionette, _) {

  Marionette.Application.prototype.component =
  Marionette.Module.prototype.component = function(name, options) {
    var component = this[name];

    if (!component) {
      var fromComponent = _.result(options, 'fromComponent');
      var ComponentType;

      if (fromComponent) {
        ComponentType = fromComponent;
        delete options.fromComponent;
      } else {
        ComponentType = Marionette.Component;
      }

      component = ComponentType.extend(options || {});
      this[name] = component;
    }

    return component;
  };

})(Marionette, _);

(function(Component, _) {

  Component.define = function(options) {
    _.extend(this.prototype, options);
  };

})(Marionette.Component, _);

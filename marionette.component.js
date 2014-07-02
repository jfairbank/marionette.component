// Marionette.Component
// ====================
// v0.0.1
//
// Copyright (c)2014 Jeremy Fairbank
// Distributed under MIT license

(function(Marionette, _) {

  // Marionette.Component
  // --------------------
  // An object to represent an application component, typically 
  // something visual, encapsulated in to an object that can be 
  // instantiated and dispalyed on screen as needed.
  //
  // Marionette.Component can optionally have a `region`, `model`,
  // and/or `collection` passed to it through the constructor options.

  Marionette.Component = Marionette.Controller.extend({
    constructor: function(options) {
      options = options || {};

      this.region     = options.region;
      this.model      = options.model;
      this.collection = options.collection;

      Marionette.Controller.prototype.constructor.apply(this, arguments);
    },

    show: function() {
      this.showLayout();
    },

    showLayout: function() {
      var layout = this.layout = this.getLayout();

      this.listenTo(layout, 'show', function() {
        this.triggerMethod('show:layout');
      });

      this.region.show(layout);
    }
  });

})(Marionette, _);

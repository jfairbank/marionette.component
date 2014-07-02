// Marionette.Component
// --------------------
// An object to represent an application component, typically 
// something visual, encapsulated in to an object that can be 
// instantiated and dispalyed on screen as needed.
//
// Marionette.Component can optionally have a `region`, `model`,
// and/or `collection` passed to it through the constructor options.

var Component = Marionette.Controller.extend({
  constructor: function(options) {
    options = options || {};

    this.region     = options.region;
    this.model      = options.model;
    this.collection = options.collection;

    Marionette.Controller.prototype.constructor.apply(this, arguments);
  },

  show: function() {
    this._showView();
  },

  _showView: function() {
    var view = this.view = this._getView();

    this.listenTo(view, 'show', function() {
      this.triggerMethod('show:view');
    });

    this.region.show(view);
  }
});

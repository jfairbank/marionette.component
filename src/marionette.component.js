// Marionette.Component
// --------------------
// An object to represent an application component, typically 
// something visual, encapsulated in to an object that can be 
// instantiated and dispalyed on screen as needed.
//
// Marionette.Component can optionally have a `region`, `model`,
// and/or `collection` passed to it through the constructor options.

Marionette.Component = Marionette.Object.extend({
  constructor: function(options) {
    options = options || {};

    this.model      = options.model;
    this.collection = options.collection;

    Marionette.Object.prototype.constructor.apply(this, arguments);
  },

  // Show this component inside a region
  showIn: function(region) {
    if (this._isShown) {
      throw new Error('This component is already shown in a region.');
    }

    if (!region) {
      throw new Error('Please supply a region to show inside.');
    }

    this.region = region;

    this.triggerMethod('before:show');

    this._showView();
    this._isShown = true;

    this.triggerMethod('show');
  },

  // Destroy the component and view
  destroy: function() {
    if (this._isDestroyed) {
      return;
    }

    this.triggerMethod('before:destroy');

    this._destroyViewThroughRegion();
    this._removeReferences();

    this.triggerMethod('destroy');
    this.stopListening();

    this._isDestroyed = true;
  },

  // Show the view in the region
  _showView: function() {
    var view = this.view = this._getView();

    // Trigger show:view after the view is shown in the region
    this.listenTo(view, 'show', _.partial(this.triggerMethod, 'show:view'));

    // Trigger before:show before the region shows the view
    this.triggerMethod('before:show:view');

    // Show the view in the region
    this.region.show(view);

    // Destroy the component if the region is emptied because it destroys
    // the view
    this.listenToOnce(this.region, 'empty', this.destroy);
  },

  // Get an instance of the view to display
  _getView: function() {
    var ViewClass = this.viewClass;

    if (!ViewClass) {
      throw new Error('You must specify a viewClass for your component.');
    }

    return new ViewClass({
      model: this.model,
      collection: this.collection
    });
  },

  _destroyViewThroughRegion: function() {
    var region = this.region;

    // Don't do anything if there isn't a region or view.
    // We need to check the view or we could empty the region before we've
    // shown the component view. This would destroy an existing view in the
    // region.
    if (!region || !this.view) {
      return;
    }

    // Remove listeners on region, so we don't call `destroy` a second time
    this.stopListening(region);

    // Destroy the view by emptying the region
    region.empty();
  },

  // Remove references to all attached objects
  _removeReferences: function() {
    delete this.model;
    delete this.collection;
    delete this.region;
    delete this.view;
  }
});

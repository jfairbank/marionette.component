# Marionette.Component

[![Build Status](https://travis-ci.org/jfairbank/marionette.component.svg?branch=master)](https://travis-ci.org/jfairbank/marionette.component)

Manage and create components for your Marionette.js application

## Reusable Components in Marionette

Marionette.Component is a library for creating reusable components in Marionette.js. Marionette.Component offers an opinionated, standardized approach to creating components with your Marionette views. The library exposes an API for displaying components in Marionette regions and handles the entire view lifecycle inside the region.

## Installation

### Via npm

`$ npm install marionette.component`

### Via bower

`$ bower install marionette.component`

## Motivation

So why a separate layer? Aren't views good enough? Yes, but typically applications take two approaches to creating reusable components. Either you create a reusable view that may contain extra business logic or you create a parent object/controller that manages the lifecycle of the view. To help enforce separation of concerns, Marionette.Component handles the former by being a wrapper object for business logic. It handles the latter by being a parent object that offers a standardized API and manages the lifecycle of the view automatically, eliminating repeated view management patterns in applications.

## Usage

Creating components is very simple and at minimum requires only a component definition and view class.

```js
var MyView = Marionette.ItemView.extend({
  template: _.template('Hello World')
});

var MyComponent = Marionette.Component.extend({
  viewClass: MyView
});

var component = new MyComponent();
```

To display a component inside a region, call `showIn` with the region instance as the argument.

```js
var MyApp = Marionette.Application.extend({
  regions: {
    mainRegion: '#main'
  }
});

var app = new MyApp();
var region = app.getRegion('mainRegion');

var component = new MyComponent();

component.showIn(region);

component.view instanceof MyView; //=> true
component.region === region;      //=> true
region.$el.text();                //=> 'Hello World'
```

Remember that components are reusable, so you can instantiate them multiple times and display them in different regions.

```js
var MyApp = Marionette.Application.extend({
  regions: {
    sidebarRegion1: '#sidebar-1',
    sidebarRegion2: '#sidebar-2',
    sidebarRegion3: '#sidebar-3'
  }
});

var component1 = new MyComponent();
var component2 = new MyComponent();
var component3 = new MyComponent();

var app = new MyApp();
var regions = app.getRegions();

component1.showIn(regions.sidebarRegion1);
component2.showIn(regions.sidebarRegion2);
component3.showIn(regions.sidebarRegion3);
```

Components also take a model and/or collection option that will be passed along to the view.

```js
var Foo = Backbone.Model.extend();
var List = Backbone.Collection.extend();

var component = new MyComponent({
  model: new Foo(),
  collection: new List()
});

component.model      instanceof Foo;  //=> true
component.collection instanceof List; //=> true

component.model      === component.view.model;      //=> true
component.collection === component.view.collection; //=> true
```

Components can capture events triggered on the view and react to them.

```js
var MyComponent = Marionette.Component.extend({
  viewClass: MyView,

  viewEvents: {
    'foo': 'handleFoo',
    'select:bar': function(arg) {
      console.log('selected bar', arg);
    }
  },

  handleFoo: function() {
    console.log('handle foo');
  }
});

var component = new Component();
component.showIn(region);

component.view.trigger('foo');            // 'handle foo'
component.view.trigger('select:bar', 42); // 'selected bar 42'
```

## API

### **showIn(region)**

Show the component inside `region`. It triggers the following events on the component: `before:show`, `before:show:view`, `show:view`, `show`. With each event, it also calls the appropriate `on*` method, if available (thanks to `triggerMethod`).

### **destroy()**

Destroy the component and view. It will empty the region, destroy the view, and remove references to any model and collection, as well as references to the view and region. It triggers two events, `before:destroy` and `destroy`, each with their respective `on*` callback from `triggerMethod`.

### Marionette.Object.prototype

Marionette.Component inherits from [Marionette.Object](http://marionettejs.com/docs/v2.1.0/marionette.object.html), so all of its methods are available too (of course, `destroy` is overriden by Marionette.Component's own implementation).

## Definition options

### **viewClass** (\*required)

The view class to be associated with the component. When calling `showIn`, the component will create an instance of the view class and attach it as a `view` property to the component. The component will also forward along any `model` and/or `collection` properties to the view.

### **viewEvents**

Optional object literal of view events to method handlers on the component. **Please NOTE:** this refers to events triggered directly on the view, **NOT** DOM events that the view itself might handle.

## Contributing/Feature Requests

Marionette.Component is a very young project with a lot of potential. If you have any ideas or feature requests, please feel free to open a pull request or issue. For PR's, please branch off `dev`.

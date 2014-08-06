var chai      = require('chai');
var sinon     = require('sinon');
var sinonChai = require('sinon-chai');
var chaiJq    = require('chai-jq');

chai.use(sinonChai);
chai.use(chaiJq);

global.expect = chai.expect;
global.sinon  = sinon;

if (!global.document || !global.window) {
  var jsdom = require('jsdom').jsdom;
  var docHtml = '<html><head><script></script></head><body></body></html>';

  global.document = jsdom(docHtml, null, {
    FetchExternalResources: ['script'],
    ProcessExternalResources: ['script'],
    MutationEvents: '2.0',
    QuerySelector: false
  });

  global.window = document.createWindow();
  global.navigator = global.window.navigator;

  global.window.Node.prototype.contains = function (node) {
    return this.compareDocumentPosition(node) & 16;
  };
}

global.root = global.window;
global.$ = global.jQuery = require('jquery');
global._ = require('underscore');
global.Backbone = require('backbone');
global.Backbone.$ = global.$;
global.Marionette = require('backbone.marionette');
global.Component = require('./marionette.component');
global.Marionette.Component = global.Component;

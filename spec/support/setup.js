var sinon = require('sinon');
var $     = require('jquery');
var $body = $(document.body);

var setFixtures = function() {
  _.each(arguments, function(content) {
    $body.append(content);
  });
};

var clearFixtures = _.bind($body.empty, $body);

beforeEach(function() {
  this.sinon         = sinon.sandbox.create();
  this.setFixtures   = setFixtures;
  this.clearFixtures = clearFixtures;
});

afterEach(function() {
  this.sinon.restore();
  clearFixtures();
});

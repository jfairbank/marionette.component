describe 'Marionette.Component', ->
  beforeEach ->
    @setFixtures '<div id="main"></div>'

    @MyRegion = Marionette.Region.extend(el: '#main')
    @MyView   = Marionette.ItemView.extend(template: _.template('foo bar'))

    @options =
      model:      new Backbone.Model()
      collection: new Backbone.Collection()
      region:     new @MyRegion()

  describe 'when viewClass is specified', ->
    beforeEach ->
      @MyComponent = Component.extend(viewClass: @MyView)

      @component = new @MyComponent(@options)
      @component.show()

    it 'assigns the view', ->
      expect(@component.view).to.be.an.instanceof(@MyView)

    it 'assigns the model to the view', ->
      expect(@component.view.model).to.equal(@options.model)

    it 'assigns the collection to the view', ->
      expect(@component.view.collection).to.equal(@options.collection)

  describe 'when viewClass is missing', ->
    beforeEach ->
      @MyComponent = Component.extend()
      @component = new @MyComponent(@options)
      @run = @component.show.bind(@component)

    it 'throws an error', ->
      expect(@run).to.throw('You must specify a viewClass for your component.')

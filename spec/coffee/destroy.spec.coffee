describe 'Marionette.Component', ->
  sharedTests = (options = {}) ->
    options.emptiesRegion = true unless options.emptiesRegion?

    if options.emptiesRegion
      it 'destroys the view', ->
        expect(@view.isDestroyed).to.be.true

      it 'empties the region', ->
        expect(@emptySpy)
          .to.have.been.called
          .and.have.been.calledOn(@region)

        expect(@region.hasView()).to.be.false

      it 'removes the reference to the view', ->
        expect(@component.view).to.be.undefined
    else
      it 'does not empty the region', ->
        expect(@emptySpy).to.not.have.been.called

    it 'removes the reference to the region', ->
      expect(@component.region).to.be.undefined

    it 'removes the reference to the entities', ->
      expect(@component.model).to.be.undefined
      expect(@component.collection).to.be.undefined

    it 'calls onBeforeDestroy on the component', ->
      expect(@onBeforeDestroyStub)
        .to.have.been.calledOnce
        .and.have.been.calledOn(@component)

    it 'calls onDestroy on the component', ->
      expect(@onDestroyStub)
        .to.have.been.calledOnce
        .and.have.been.calledOn(@component)

  beforeEach ->
    # Fixtures for region
    @setFixtures '<div id="main"></div>'

    # Component stubs
    @onBeforeDestroyStub = @sinon.stub()
    @onDestroyStub       = @sinon.stub()

    # Region spies
    @emptySpy = @sinon.spy(Marionette.Region.prototype, 'empty')

    # MyRegion
    @MyRegion = Marionette.Region.extend(el: '#main')
    @region   = new @MyRegion()

    # MyView
    @MyView = Marionette.ItemView.extend(template: _.template('foo bar'))

    # MyComponent
    @MyComponent = Component.extend
      viewClass:       @MyView
      onBeforeDestroy: @onBeforeDestroyStub
      onDestroy:       @onDestroyStub

    # Options for component
    @options =
      model:      new Backbone.Model()
      collection: new Backbone.Collection()

    # Set up and call `destroy`
    @component = new @MyComponent(@options)

  describe 'when calling `destroy` on the component', ->
    beforeEach ->
      @component.showIn(@region)
      @view = @component.view
      @component.destroy()

    sharedTests()

  describe 'when emptying the region', ->
    beforeEach ->
      @component.showIn(@region)
      @view = @component.view
      @region.empty()

    sharedTests()

  describe 'when calling `destroy` before the component has been shown', ->
    beforeEach -> @component.destroy()
    sharedTests(emptiesRegion: false)

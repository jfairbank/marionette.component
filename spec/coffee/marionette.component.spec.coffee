describe 'Marionette.Component', ->
  beforeEach ->
    @setFixtures '<div id="main"></div>'

  it 'inherits from Marionette.Controller', ->
    expect(new Component()).to.be.an.instanceof(Marionette.Controller)

  describe 'when instantiating', ->
    beforeEach ->
      @ControllerSpy = @sinon.spy(Marionette.Controller.prototype, 'constructor')
      @component = new Component()

    it 'calls the Controller constructor', ->
      expect(@ControllerSpy).to
        .have.been.calledOnce
        .and.have.been.calledOn(@component)

  describe 'when instantiating with options', ->
    beforeEach ->
      @ControllerSpy = @sinon.spy(Marionette.Controller.prototype, 'constructor')

      @options =
        region:     new Marionette.Region(el: '#main')
        model:      new Backbone.Model()
        collection: new Backbone.Collection()

      @component = new Component(@options)

    it 'assigns the region', ->
      expect(@component.region).to.equal(@options.region)

    it 'assigns the model', ->
      expect(@component.model).to.equal(@options.model)

    it 'assigns the collection', ->
      expect(@component.collection).to.equal(@options.collection)

    it 'calls the Controller constructor with the options', ->
      expect(@ControllerSpy).to
        .have.been.calledOnce
        .and.have.been.calledOn(@component)
        .and.have.been.calledWith(@options)

  describe 'when showing', ->
    beforeEach ->
      # Region and view
      @region = new Marionette.Region(el: '#main')
      @MyView = Marionette.ItemView.extend(template: _.template('foo bar'))

      # Stubs and spies
      @showViewSpy       = @sinon.spy(Component.prototype, '_showView')
      @onShowViewStub    = @sinon.stub()
      @regionShow        = @sinon.spy(Marionette.Region.prototype, 'show')
      @triggerMethodStub = @sinon.spy(Component.prototype.triggerMethod)

      # Component definition
      @MyComponent = Component.extend
        viewClass: @MyView
        onShowView: @onShowViewStub
        triggerMethod: @triggerMethodStub

      # Component instance
      @component = new @MyComponent(region: @region)
      @component.show()

    it 'calls `_showView`', ->
      expect(@showViewSpy).to
        .have.been.calledOnce
        .and.have.been.calledOn(@component)

    it 'calls `triggerMethod`', ->
      expect(@triggerMethodStub).to
        .have.been.calledOnce
        .and.have.been.calledOn(@component)
        .and.have.been.calledWith('show:view')
        .and.have.been.calledAfter(@regionShow)
        .and.have.been.calledBefore(@onShowViewStub)

    it 'calls `onShowView`', ->
      expect(@onShowViewStub).to
        .have.been.calledOnce
        .and.have.been.calledOn(@component)

    it 'calls the `show` method on the region', ->
      expect(@regionShow).to
        .have.been.calledOnce
        .and.have.been.calledOn(@region)
        .and.have.been.calledWith(@component.view)

    it 'displays the view content in the region', ->
      expect(@region.$el).to.have.$text('foo bar')

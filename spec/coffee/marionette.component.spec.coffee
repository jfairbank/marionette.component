describe 'Marionette.Component', ->
  beforeEach ->
    @setFixtures '<div id="main"></div>'

  it 'inherits from Marionette.Object', ->
    expect(new Component()).to.be.an.instanceof(Marionette.Object)

  describe 'when instantiating', ->
    beforeEach ->
      @ObjectSpy = @sinon.spy(Marionette.Object.prototype, 'constructor')
      @component = new Component()

    it 'calls the Object constructor', ->
      expect(@ObjectSpy).to
        .have.been.calledOnce
        .and.have.been.calledOn(@component)

  describe 'when instantiating with options', ->
    beforeEach ->
      @ObjectSpy = @sinon.spy(Marionette.Object.prototype, 'constructor')

      @options =
        model:      new Backbone.Model()
        collection: new Backbone.Collection()

      @component = new Component(@options)

    it 'assigns the model', ->
      expect(@component.model).to.equal(@options.model)

    it 'assigns the collection', ->
      expect(@component.collection).to.equal(@options.collection)

    it 'calls the Object constructor with the options', ->
      expect(@ObjectSpy).to
        .have.been.calledOnce
        .and.have.been.calledOn(@component)
        .and.have.been.calledWith(@options)

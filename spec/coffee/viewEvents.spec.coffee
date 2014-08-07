describe 'Marionette.Component', ->
  describe 'viewEvents', ->
    beforeEach ->
      # Fixtures
      @setFixtures '<div id="main"></div>'

      # View and region
      @MyView   = Marionette.ItemView.extend(template: false)
      @MyRegion = Marionette.Region.extend(el: '#main')
      @region   = new @MyRegion()

      # Stubs
      @handleFooStub = @sinon.stub()
      @handleBarStub = @sinon.stub()

      # Component
      @MyComponent = Component.extend
        viewClass: @MyView

        viewEvents:
          'foo': 'handleFoo'
          'bar': @handleBarStub

        handleFoo: @handleFooStub

      # Set up and trigger events
      @component = new @MyComponent()
      @component.showIn(@region)

      @fooArgs = [42]
      @barArgs = ['hello', 'world']

      @component.view.trigger('foo', @fooArgs...)
      @component.view.trigger('bar', @barArgs...)

    it 'calls the foo event handler', ->
      expect(@handleFooStub)
        .to.have.been.calledOnce
        .and.have.been.calledOn(@component)
        .and.have.been.calledWith(@fooArgs...)

    it 'calls the bar event handler', ->
      expect(@handleBarStub)
        .to.have.been.calledOnce
        .and.have.been.calledOn(@component)
        .and.have.been.calledWith(@barArgs...)

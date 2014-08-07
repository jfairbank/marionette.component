describe 'Marionette.Component', ->
  beforeEach ->
    @setFixtures '<div id="main"></div>'

  describe 'when showing', ->
    beforeEach ->
      # Region and view
      @MyRegion = Marionette.Region.extend(el: '#main')
      @MyView   = Marionette.ItemView.extend(template: _.template('foo bar'))
      @region   = new @MyRegion()

      # Stubs and spies
      @showViewSpy          = @sinon.spy(Component.prototype, '_showView')
      @onBeforeShowStub     = @sinon.stub()
      @onShowStub           = @sinon.stub()
      @onBeforeShowViewStub = @sinon.stub()
      @onShowViewStub       = @sinon.stub()
      @regionShow           = @sinon.spy(Marionette.Region.prototype, 'show')
      @triggerMethodStub    = @sinon.spy(Component.prototype.triggerMethod)

      # Component definition
      @MyComponent = Component.extend
        viewClass:        @MyView
        onBeforeShow:     @onBeforeShowStub
        onShow:           @onShowStub
        onBeforeShowView: @onBeforeShowViewStub
        onShowView:       @onShowViewStub
        triggerMethod:    @triggerMethodStub

      # Component instance
      @component = new @MyComponent()

    describe 'with the region', ->
      beforeEach -> @component.showIn(@region)

      it 'calls `_showView`', ->
        expect(@showViewSpy)
          .to.have.been.calledOnce
          .and.have.been.calledOn(@component)

      it 'calls `triggerMethod`', ->
        expect(@triggerMethodStub)
          .to.have.callCount(4)
          .and.have.been.calledOn(@component)
          .and.have.been.calledWith('before:show')
          .and.have.been.calledWith('before:show:view')
          .and.have.been.calledWith('show:view')
          .and.have.been.calledWith('show')

      it 'calls `onBeforeShow`', ->
        expect(@onBeforeShowStub)
          .to.have.been.calledOnce
          .and.have.been.calledOn(@component)
          .and.have.been.calledBefore(@onBeforeShowViewStub)
          .and.have.been.calledBefore(@onShowViewStub)
          .and.have.been.calledBefore(@onShowStub)

      it 'calls `onBeforeShowView`', ->
        expect(@onBeforeShowViewStub)
          .to.have.been.calledOnce
          .and.have.been.calledOn(@component)
          .and.have.been.calledBefore(@onShowViewStub)
          .and.have.been.calledBefore(@onShowStub)

      it 'calls `onShowView`', ->
        expect(@onShowViewStub)
          .to.have.been.calledOnce
          .and.have.been.calledOn(@component)
          .and.have.been.calledBefore(@onShowStub)

      it 'calls `onShow`', ->
        expect(@onShowStub)
          .to.have.been.calledOnce
          .and.have.been.calledOn(@component)

      it 'calls the `show` method on the region', ->
        expect(@regionShow)
          .to.have.been.calledOnce
          .and.have.been.calledOn(@region)
          .and.have.been.calledWith(@component.view)

      it 'displays the view content in the region', ->
        expect(@region.$el).to.have.$text('foo bar')

      it 'creates a reference to the region', ->
        expect(@component.region).to.equal(@region)

    describe 'and when calling twice', ->
      beforeEach ->
        @run = =>
          @component.showIn(@region)
          @component.showIn(@region)

      it 'throws an error', ->
        expect(@run).to.throw('This component is already shown in a region.')

    describe 'without a region', ->
      beforeEach ->
        @run = @component.showIn.bind(@component)

      it 'throws an error', ->
        expect(@run).to.throw('Please supply a region to show inside.')

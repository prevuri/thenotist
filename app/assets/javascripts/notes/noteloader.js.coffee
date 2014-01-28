NoteLoader = () ->

  @setWidth = 0


  $(window).resize( () ->
    @scalePageOnResize()
    )

  $(window).load( () ->
    @scalePageOnLoad()
    )

  @loadPageFromUrl = (url) =>
    # load the page from url and then hide the spinner container

  @initiateLoadForNextPage = () =>
    # attain the url from the page dom and intiate page load


  @scalePageOnResize = () =>
    @scalePageOnLoad()


    #scale transform the page when it is resized
    #on page resize record initial page size and destination page size
    #compute ratio and scale accordingly


  @scalePageOnLoad = () =>
    wantedWidthRatio = 0.57
    @setWidth = $(window).width()
    @page = $('.page-container')

    pageWidth = @page.width()

    currentRatio = pageWidth/@setWidth

    @page.css('transform-origin', 'left')
    @page.css('-moz-transform-origin', 'left')
    @page.css('-webkit-transform-origin', 'left')
    @page.css('-o-transform-origin', 'left')

    @page.css('transform', 'scale(' + wantedWidthRatio/currentRatio + ')' )
    @page.css('-moz-transform', 'scale(' + wantedWidthRatio/currentRatio + ')' )
    @page.css('-webkit-transform', 'scale(' + wantedWidthRatio/currentRatio + ')' )
    @page.css('-o-transform', 'scale(' + wantedWidthRatio/currentRatio + ')' )


$ ->
  if $('.page-container').length > 0
    NoteLoader()



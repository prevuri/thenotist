notistApp = angular.module('notistApp')

# For use with progress spinners - starts a jQuery spin animation
#    set ng-spin="attr" where attr is boolean for spinning on/off
notistApp.directive('ngSpinner', () ->
  (scope, el, attr) ->
    if attr.ngSpinner is 'true'
      $(el).spin
        lines: 7,
        length: 0,
        width: 5,
        radius: 10,
        corners: 1.0,
        trail: 50,
        speed: 1.2,
        shadow: false,
        color: '#a6a6a6'
)

# For file upload forms to detect when a file has been selected
.directive('ngUpload', () ->
  (scope, el, attr) ->
    $(el).fileupload
      dataType: 'json'
      add: (e, data) =>
        scope.uploadAdd(data)
        scope.$apply()
      progress: (e, data) =>
        scope.uploadProgress(data)
        scope.$apply()
      done: (e, data) =>
        scope.uploadDone(data)
        scope.$apply()
      fail: (e, data) =>
        scope.uploadFail(data)
        scope.$apply()
)

# Make clicking an element simulate the click of another, specified by ID
.directive('ngSimulateClick', () ->
  (scope, el, attr) ->
    if attr.ngSimulateClick
      $(el).on('click', () ->
        document.getElementById(attr.ngSimulateClick).click()
        scope.$apply()
      )
)

.directive('compile', ($compile, $parse) ->
  link: (scope, el, attr) ->
    parsed = $parse(attr.ngBindHtml)
    getStringValue = () ->
      (parsed(scope) || '').toString()
    scope.$watch(getStringValue, () ->
      $compile(el, null, -9999)(scope)
    )
)

.directive('textareaAutoheight', () ->
  link: (scope, el, attrs) ->
    setHeight = () ->
      $(el).height(0) # Reset height to put scrollHeight at minimum value, so textarea shrinks when text is deleted
      $(el).height(el[0].scrollHeight)
    $(el).bind('input propertychange focus', setHeight)
    scope.$watch(attrs.textareaAutoheight, setHeight, true)
)

.directive('textareaAutoheightReadonly', () ->
  link: (scope, el, attrs) ->
    setHeight = () ->
      $(el).height(0)
      $(el).height(el[0].scrollHeight)
    $(el).ready(setHeight)
    scope.$watch('expandedCommentLine', setHeight, true)
)

.directive('textareaAutofocus', ($timeout) ->
  link: (scope, el, attrs) ->
    setFocus = (value) ->
      if value
        $timeout( () ->
          $(el).focus()
        , 10)
    scope.$watch(attrs.textareaAutofocus, setFocus, true)
)

.directive('pageButtonsScroll', () ->
  link: (scope, el, attrs) ->
    ctrlScope = scope.$parent.$parent
    ctrlScope.pageEl[scope.pageNo] = el
    scope.pageEl = el
    scrollToPage = () =>
      if scope.pageEl.scrollToPage
        $(document).scrollTop(el[0].offsetTop-$('#note-header').height())
        scope.pageEl.scrollToPage = false
    scope.$watch('pageEl.scrollToPage', scrollToPage)
)

.directive('scrollChangePage', ($timeout) ->
  link: (scope, el, attrs) ->
    checkPage = (el, i, docScroll) =>
      if docScroll - el[0].offsetTop < scope.elHeight/ 2 &&
      docScroll - el[0].offsetTop > scope.elHeight/-2
        if (i != scope.currentPage)
          scope.currentPage = i
          scope.$apply()
        return true
      return false

    changeCurrentPage = () =>
      if scope.previousScroll == undefined
        scope.previousScroll = 0
      if !scope.elHeight
        scope.elHeight = $(scope.pageEl[1]).height()
      previous = scope.previousScroll
      docScroll = $(document).scrollTop()
      scope.previousScroll = docScroll
      if docScroll > previous
        for i in [scope.currentPage..scope.note.uploaded_html_files.length]
          if checkPage(scope.pageEl[i], i, docScroll)
            return
      else if docScroll < previous
        for i in [scope.currentPage..1]
          if checkPage(scope.pageEl[i], i, docScroll)
            return
    $(document).ready( () =>
      $(document).scroll(() =>
        if !scope.isScrolling
          changeCurrentPage()
          scope.isScrolling = true
          $timeout(() ->
            scope.isScrolling = false
            changeCurrentPage()
          , 200)
      )
    )
)

.directive('placeholderHeight', () ->
  link: (scope, el, attrs) ->
    scope.$watch('placeholderHeight', () =>
      $(el).height(scope.placeholderHeight)
    )
)

.directive('animateTimeout', ($timeout) ->
  link: (scope, el, attrs) ->
    $timeout(()->
      scope.animate = true
    , 100)
)

.directive('ngEnter', () ->
  link: (scope, el, attrs) ->
    $('body').bind('keydown keypress', (e) ->
      if e.which == 13
        scope.$eval(attrs.ngEnter)
        e.preventDefault()
    )
)

.directive('leftArrow', ($timeout) ->
  link: (scope, el, attrs) ->
    canPress = true
    $('body').bind('keydown keypress', (e) ->
      if e.which == 37 && canPress
        scope.$eval(attrs.leftArrow)
        e.preventDefault()
        canPress = false
        $timeout( () ->
          canPress = true
        , 50)
    )
    $('body').bind('keyup', (e) ->
      if e.which == 37 && !canPress
        canPress = true
    )
)

.directive('rightArrow', ($timeout) ->
  link: (scope,element,attrs) ->
    canPress = true
    $('body').bind('keydown keypress', (e) ->
      if e.which == 39 && canPress
        scope.$eval(attrs.rightArrow)
        e.preventDefault()
        canPress = false
        $timeout( () ->
          canPress = true
        , 50)
    )
    $('body').bind('keyup', (e) ->
      if e.which == 39 && !canPress
        canPress = true
    )
)

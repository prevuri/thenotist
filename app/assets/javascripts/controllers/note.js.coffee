@NoteCtrl = ($scope, $http, $route, $routeParams, $sce, NotesApi) ->

  $route.current.templateUrl = '/ng/notes/' + $routeParams.noteId

  $scope.init = () ->
    $scope.$root.section = 'notes'
    success = (data) ->
      $scope.note = data.note
      $scope.$root.title = $scope.note.title
      $scope.trustURLs()
    error = (data) ->
      $scope.setAlert("Error loading note data", false)
    NotesApi.get({id: $routeParams.noteId}, success, error)

  $scope.trustURLs = () ->
    for file in $scope.note.uploaded_html_files
      file.trusted_path = $sce.trustAsResourceUrl(file.public_path)

  $scope.getComments = (id, index) ->
    $http({method: 'GET', url: '/api/comments', params: {file_id: id}}).
      success( (data, status, headers, config) ->
        $scope.note.uploaded_html_files[index].comments = data.comments
      ).error( (data, status, headers, config) ->
        $scope.setAlert("Error loading comments from server", false)
    )

  $scope.showNewComment = (show) ->
    $scope.showingNewComment = show
    $scope.$root.pageShifted = show

  $scope.lineClick = (lineId) ->
    $scope.newCommentLineId = lineId
    $scope.parentId = null
    $scope.showNewComment(true)
    lineEl = $('[data-guid='+lineId+']')
    $scope.newCommentY = $(lineEl).offset().top
    $scope.newCommentFileId = this.$parent.file.id
    $scope.newCommentFileIndex = this.$parent.$index
    $scope.expandedCommentLine = null

  $scope.commentY = (lineId) ->
    el = $('[data-guid='+lineId+']')
    $(el).offset().top - $(el).parents('.note-page').offset().top

  $scope.canReply = (comment) ->
    comment.parent_comment_id == null

  $scope.expandCommentLine = (lineId) ->
    $scope.expandedCommentLine = if $scope.expandedCommentLine == lineId then null else lineId
    $scope.$root.pageShifted = $scope.expandedCommentLine != null
    if $scope.expandedCommentLine != null
      $scope.showingNewComment = false

  $scope.submitParentComment = () ->
    $scope.submitComment($scope.newCommentText, $scope.newCommentFileId, null, $scope.newCommentFileIndex)

  $scope.submitReply = (parentComment, fileId, fileIndex) ->
    $scope.submitComment(parentComment.newReplyText, fileId, parentComment.id, fileIndex)

  $scope.submitComment = (text, fileId, parentId, fileIndex) ->
    if !$scope.submitting
      data = {
        comment: {
          text: text,
        },
        file_id: fileId
      }
      if parentId
        data['comment']['parent_id'] = parentId
      else
        data['comment']['line_id'] = $scope.newCommentLineId

      $scope.submitting = true
      $http({method: 'POST', url: '/api/comments', data: data}).
        success( (data, status, headers, config) ->
          $scope.note.uploaded_html_files[fileIndex].comments = data.comments
          $scope.showNewComment(false)
          $scope.submitting = false
          $scope.newCommentText = null
        ).error( (data, status, headers, config) ->
          # TODO: error message of some sort
          $scope.submitting = false
      )

  $scope.deleteComment = (comment) ->
    comment.showDeleteConfirm = false
    comment.deleteFade = true
    $http({method: 'DELETE', url: '/api/comments/' + comment.id}).
        success( (data, status, headers, config) ->
          comment.deleted = true
        ).error( (data, status, headers, config) ->
          $scope.setAlert("Error deleting comment", false) 
          comment.deleteFade = false
      )

  $scope.resetFlagReportForm = () ->
    $('#flag-description-field').val('')
    $("input:radio[name=flag_report_category][id=default]").prop('checked', true) 


  $scope.submitReport = (noteId) ->
    
    data = {'note_id': noteId, 'report_type': $("input:radio[name=flag_report_category]").val(), 'report_description': $('#flag-description-field').val(),
          }
    $http({method: 'POST', url: '/api/flag_reports', params: data}).
      success( (data, status, headers, config) ->
        console.log("Flag Report has been sent")
        $('.flag-report-form-container').modal('hide');
        $scope.resetFlagReportForm();
        #TODO update with angular alerts
        alert "Thank you! Your flag report has been sent."
      ).error( (data, status, headers, config) ->
        alert data        
        #TODO update with angular alerts
        alert "Sorry! Your flag report failed to send."
      )

@NotesCtrl = ($scope, $http, $sce, $interval, $filter, NotesApi) ->

  $scope.overview = {
    'images': '',
    'showing': false
  }

  $scope.notesProcessing = Array()
  $scope.isNoteProcessed = {}
  $scope.promises = {}
  $scope.notes = Array()

  $scope.init = () ->
    console.log '[Angular] NotesCtrl being initialized'
    $scope.$root.title = 'Notes'
    $scope.$root.section = 'notes'
    $scope.updateNotes()

  $scope.updateNotes = () ->
    success = (data) ->
      $scope.notes = data.notes
      for note in $scope.notes
        if !note.processed
          $scope.notesProcessing.push note.id
          $scope.initPolling(note.id)
    error = (data) ->
      $scope.setAlert("Error loading notes list", false)
    NotesApi.get(success, error)

  $scope.deleteNote = (note, index) ->
    success = (data) ->
      $scope.notes.splice(index, 1)
    error = (data) ->
      $scope.setAlert("Error deleting note", false)
    NotesApi.delete({id: note.id}, success, error)

  # $scope.shareNote = () ->
  #   success = (data) ->
  #     $scope.notes = data.notes
  #     for note in $scope.notes
  #       if note.processing
  #         $scope.notesProcessing = true
  #         break
  #   error = (data) ->
  #     $scope.setAlert("Error loading notes list", false)
  #   NotesApi.update({id: note.id, success, error})

  #  $scope.$on('processingStarted', (event, args) ->
  #   $scope.notesProcessing.push args.id
  #   $scope.initPolling(args.id)
  # )

  $scope.checkNoteStatus = (noteId) ->
    success = (data) ->
      procNote = data.note 
      if procNote.processed
        existingNote = $filter('filter')($scope.notes, {id: data.note.id}, true)[0]
        existingNote.processed = true
        existingNote.uploaded_html_files = procNote.uploaded_html_files
        existingNote.uploaded_css_files = procNote.uploaded_css_files
        existingNote.uploaded_thumb_files = procNote.uploaded_thumb_files
        noteIndex = $scope.notesProcessing.indexOf(procNote.id)
        $scope.notesProcessing.splice(noteIndex, 1)
        clearInterval($scope.promises[noteId])
        delete $scope.promises[noteId]
    error = (data) ->
      $scope.setAlert("Error getting note", false)
    NotesApi.get({id: noteId}, success, error)

  $scope.initPolling = (noteId) ->
    $scope.promises[noteId] = window.setInterval(@checkNoteStatus, 5000, noteId)


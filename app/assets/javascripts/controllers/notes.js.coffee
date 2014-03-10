@NotesCtrl = ($scope, $http, $sce, $interval, $filter, NotesApi) ->

  # Variable to check for polling and notes that are processing.
  $scope.notesProcessing = Array()
  $scope.isNoteProcessed = {}
  $scope.promises = {}
  $scope.notes = Array()

  # Init
  $scope.init = () ->
    console.log '[Angular] NotesCtrl being initialized'
    $scope.$root.title = 'Notes'
    $scope.$root.section = 'notes'
    $scope.button = 'date'
    $scope.reverse = false
    $scope.updateNotes()
    # $scope.colorize()

  # Updates all the notes on the page
  $scope.updateNotes = () ->
    success = (data) ->
      $scope.notes = $filter('orderBy')(data.notes, 'created_at')
      for note in $scope.notes
        if note.user.id == $scope.currentUser.id
          note.shared = false
        else
          note.shared = true

        if !note.processed
          $scope.notesProcessing.push note.id
          $scope.initPolling(note.id)
    error = (data) ->
      $scope.setAlert("Error loading notes list", false)
    NotesApi.get(success, error)

  # Sets the current note being shared for the sharing modal
  $scope.setSharedNote = (note) ->
    $scope.sharedNote = note
    $scope.$broadcast('shareInit')

  # Deletes a user note
  $scope.deleteNote = (note, index) ->
    success = (data) ->
      $scope.notes.splice(index, 1)
    error = (data) ->
      $scope.setAlert("Error deleting note", false)
    NotesApi.delete({id: note.id}, success, error)

  # Checks if the noteId is in notes
  $scope.noteInNotes = (noteId) ->
    for note in $scope.notes
      if noteId == note.id
        return note
    null

  # Periodic check for whether a note has been processed.
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

  # Initiates polling for the processing note
  $scope.initPolling = (noteId) ->
    $scope.promises[noteId] = window.setInterval(@checkNoteStatus, 5000, noteId)

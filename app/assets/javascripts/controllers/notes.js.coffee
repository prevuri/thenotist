@NotesCtrl = ($scope, $http, $sce, $interval, $filter, NotesApi, NotesUserApi, NotesUnsubscribeApi) ->

  # Variable to check for polling and notes that are processing.
  $scope.notesProcessing = Array()
  $scope.isNoteProcessed = {}
  $scope.promises = {}
  $scope.notes = Array()
  $scope.callingController = "Notes"

  $scope.noteDeleteClicked = -1
  $scope.noteDeleteIndex = -1

  # $scope.currentUserProfile = true

  # Init
  $scope.init = (ctrl, profile, params) ->
    console.log '[Angular] NotesCtrl being initialized'
    if ctrl == "Profile"
      $scope.callingController = "Profile"
      # $scope.currentUserProfile = profile
      # $scope.idParam = param
    else
      $scope.currentUserProfile = true
      $scope.$root.title = 'Notes'
      $scope.$root.section = 'notes'
      $scope.button = 'date'
      $scope.reverse = true
    if $scope.currentUserProfile
      $scope.updateNotes()
    else
      $scope.userNotes()
    # $scope.colorize()
    
  # Updates all the notes on the page
  $scope.updateNotes = () ->
    success = (data) ->
      $scope.notes = $filter('orderBy')(data.notes, 'created_at', true)
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


  $scope.userNotes = () ->
    success = (data) ->
      $scope.notes = $filter('orderBy')(data.notes, 'created_at', true)

      for note in $scope.notes
        contributingIds = []
        for contrib in note.contributing_users
          contributingIds.push(contrib.id)
        if $scope.currentUser.id in contributingIds
          note.hasAccess = true
          note.shared = true
        else if note.user.id == $scope.currentUser.id
          note.hasAccess = true
          note.shared = false
        else
          note.hasAccess = false
    error = (data) ->
      $scope.setAlert("Error loading notes list", false)
    NotesUserApi.get($scope.idParam, success, error)

  # Computes Reversing
  $scope.setReverse = (name) ->
    if $scope.button == name
      return !$scope.reverse
    else if $scope.button == 'date'
      return true
    else if $scope.button == 'name'
      return true

  # Sets the current note being shared for the sharing modal
  $scope.setSharedNote = (note) ->
    if $scope.callingController == "Profile"
      $scope.$root.$broadcast('shareInit')
      $scope.$root.sharedNote = note

    else
      $scope.$broadcast('shareInit')
      $scope.sharedNote = note



  # Deletes a user note
  $scope.deleteNote = () ->
    # if confirm("Are you sure you want to delete " + note.title)
    success = (data) ->
      $scope.notes.splice($scope.noteDeleteIndex, 1)
      $scope.noteDeleteIndex = -1
      $scope.noteDeleteClicked = -1
    error = (data) ->
      $scope.setAlert("Error deleting note", false)
      $scope.noteDeleteIndex = -1
      $scope.noteDeleteClicked = -1
    NotesApi.delete({id: $scope.noteDeleteClicked}, success, error)

  $scope.unsubscribeNote = () ->
    success = (data) ->
      $scope.notes.splice($scope.noteDeleteIndex, 1)
      $scope.noteDeleteIndex = -1
      $scope.noteDeleteClicked = -1
    error = (data) ->
      $scope.setAlert("Error deleting note", false)
      $scope.noteDeleteIndex = -1
      $scope.noteDeleteClicked = -1
    NotesUnsubscribeApi.remove({id: $scope.noteDeleteClicked}, success, error)

  $scope.deleteClickedNote = (note, index) ->
    $scope.noteDeleteClicked = note.id
    $scope.noteDeleteIndex = index

  $scope.cancelDelete = () ->
    $scope.noteDeleteIndex = -1
    $scope.noteDeleteClicked = -1

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
      clearInterval($scope.promises[noteId])
    NotesApi.get({id: noteId}, success, error)

  # Initiates polling for the processing note
  $scope.initPolling = (noteId) ->
    $scope.promises[noteId] = window.setInterval(@checkNoteStatus, 5000, noteId)

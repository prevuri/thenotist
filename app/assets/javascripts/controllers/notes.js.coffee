@NotesCtrl = ($scope, $http, $sce, $interval, $filter, NotesApi, TagsApi, NotesUnsubscribeApi) ->

  # Variable to check for polling and notes that are processing.
  $scope.notesProcessing = Array()
  $scope.isNoteProcessed = {}
  $scope.promises = {}
  $scope.notes = Array()

  $scope.noteDeleteClicked = -1
  $scope.noteDeleteIndex = -1

  $scope.tagMaxCharacters = 15

  # Init
  $scope.init = () ->
    console.log '[Angular] NotesCtrl being initialized'
    $scope.$root.title = 'Notes'
    $scope.$root.section = 'notes'
    $scope.button = 'date'
    $scope.reverse = true
    $scope.updateNotes()
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
    $scope.sharedNote = note
    $scope.$broadcast('shareInit')

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

  $scope.tagClicked = (tag) ->
    $scope.searchText = "#" + tag.name
    $scope.searchClickedTag = true

  $scope.searchBackspacePressed = () ->
    if $scope.searchClickedTag
      $scope.searchText = null
      $scope.$apply()

  $scope.checkTags = () ->
    if $scope.searchText && $scope.searchText.indexOf('#') != -1
      $scope.searchText = '#' + $scope.searchText.replace(/#/g,'')
    $scope.searchClickedTag = false

  $scope.addButtonClicked = (event) ->
    if this.addingTag
      this.addNewTag(this.note, this.addTagText)
      event.stopPropagation()

  $scope.deselectedAddField = () ->
    if !this.mouseOnAdd
      this.addingTag = false
      this.addTagText = null

  $scope.addTagTextChanged = () ->
    this.addTagText = this.addTagText.toLowerCase()
    if this.addTagText.search(/\W|_/) != -1
      this.addTagText = this.addTagText.replace(/\W|_/g,'')
      this.addTagError = true
    if this.addTagText.length > $scope.tagMaxCharacters
      this.addTagText = this.addTagText.substring(0, $scope.tagMaxCharacters)
      this.addTagError = true

  $scope.addNewTag = (note, tagText) ->
    if this.addingTag && tagText.length > 0
      newTag = {name: tagText}
      note.tags.push newTag
      $scope.saveTags(note)
      this.addingTag = false
      this.addTagText = null

  $scope.deleteTag = (note, deletedTag) ->
    note.tags = (tag for tag in note.tags when tag.name != deletedTag.name)
    $scope.saveTags(note)

  $scope.saveTags = (note) ->
    TagsApi.save({id: note.id}, {tags: note.tags})

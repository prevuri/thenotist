notistApp = angular.module('notistApp')

notistApp.filter('searchWithTags', ['$filter', (filter) ->
  (notes, searchString) ->
    standardFilter = filter('filter')
    if !searchString || searchString[0] != '#'
      return standardFilter(notes, searchString)
    else
      filtered = []
      for note in notes
        for tag in note.tags
          if tag.name.indexOf(searchString.substring(1)) != -1
            filtered.push(note)
            break
      return filtered
])
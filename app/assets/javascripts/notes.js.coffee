# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

jQuery ->

  # GENERAL NOTE UI
  $('.notes-list-item').hover \
        (-> $(this).find('.btn-group').removeClass('hidden').fadeIn(150)), \
        (-> 
          $(this).find('.btn-group').addClass('hidden').fadeOut(150)
          $(this).find('.tooltip').addClass('hidden').fadeOut(150))
  return false

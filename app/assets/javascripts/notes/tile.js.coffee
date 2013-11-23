Tile = () ->
  # TILE
  global_footer_height = 0
  global_expanded_footer_height = 0

  $('.note-item').hover(
    (index) ->
      tile_id = $(this).attr("data-id")
      footer = $("div[data-id='"+tile_id+"'] #list-footer")
      footer_height = $(this).attr("data-footer-expanded")
      footer.animate({height:footer_height+"px"}, {duration: 150, queue: false})
      footer.animate({bottom:footer_height+"px"}, {duration: 150, queue: false})
    (index) ->
      tile_id = $(this).attr("data-id")
      footer = $("div[data-id='"+tile_id+"'] #list-footer")
      footer_height = $(this).attr("data-footer")
      footer.animate({height:footer_height+"px"}, {duration: 150, queue: false})
      footer.animate({bottom:footer_height+"px"}, {duration: 150, queue: false})
  )

  $('.note-item').each (index) ->
    # $(".notes-list ul li").width($(document).width()/4.80)
    # $(".notes-list ul li").width($(document).width()/3.59)  !!!IMPORTANT: LEARN: Never base single load dimensions on the window. Users will have different experiences with different window sizes.
    # You can easily do this server side. Should not be doing this here!!! 
    # TODO: Transfer this code to server side.

    tile_id = $(this).attr("data-id")
  
    tile = $("div[data-id='"+tile_id+"'] .img-preview")
    tile_height = tile.height()

    footer = $("div[data-id='"+tile_id+"'] #list-footer")
    footer_height = footer.height()
    $(this).attr("data-footer", footer_height)
    $(this).attr("data-footer-expanded", footer_height)

    if $("div[data-id='"+tile_id+"'] #list-footer .big-info .info").text().length > 27 
      $(this).attr("data-footer-expanded", parseInt($(this).attr("data-footer-expanded"))+$("div[data-id='"+tile_id+"'] #list-footer .big-info .info").height()+15)
    
    if $("div[data-id='"+tile_id+"'] #list-footer .big-info .description").text().length > 0
      $(this).attr("data-footer-expanded", parseInt($(this).attr("data-footer-expanded"))+$("div[data-id='"+tile_id+"'] #list-footer .big-info .description").height()+15)

    if($("div[data-id='"+tile_id+"'] #list-footer .big-info .description").text().length == 0)
      $("div[data-id='"+tile_id+"'] #list-footer .big-info .description").css("display", "none")

    tile_container = $("li[data-id='"+tile_id+"'].notes-list-item")
    tile_container.css("height", tile_height+"px")
    tile_container.css("min-width", (1.6*tile_height)+"px")

$ ->
  if $('.note-item').length > 0
    Tile()
Tile = () ->
  # TILE
  $('.note-item').each (index) ->
  	$(".notes-list ul li").width($(document).width()/4.80)
  	tile_id = $(this).attr("data-id")
  	tile_container = $("li[data-id='"+tile_id+"'].notes-list-item")
  	tile = $("div[data-id='"+tile_id+"'] img")
  	footer = $("div[data-id='"+tile_id+"'] #list-footer")
  	tile.load () =>	
  		tile_height = tile.height()
  		footer_height = footer.height()
  		tile_container.css("height", tile_height+"px")
  		if $("div[data-id='"+tile_id+"'] #list-footer .big-info .info").text().length > 27
  			footer.css("height", (footer_height+20)+"px")
  			footer.css("bottom", (footer_height+20)+"px")
  			tile.width("100%");
$ ->
  if $('.note-item').length > 0
    Tile()
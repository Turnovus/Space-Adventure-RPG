extends PanelContainer


const MAP_COLOR : Color = Color.DIM_GRAY
const MAP_MARGIN = 10.0

const PIP_RADIUS = 2.5
const PIP_COLOR_PLAYER = Color.AQUA
const PIP_COLOR_SITE = Color.BURLYWOOD

const LABEL_FONT_SIZE = 10
const LABEL_FONT_COLOR = Color.BLACK

@export var label_font : Font

var show_player : bool = true
var show_sites : bool = true

@onready var show_player_button : CheckBox = $VBoxContainer/ShowPlayerButton
@onready var show_site_button : CheckBox = $VBoxContainer/ShowSiteButton


func _ready():
	var galaxy : Galaxy = get_tree().root.get_child(0).get_galaxy()
	galaxy.turn_post.connect(_on_turn_post)
	
	show_player_button.toggled.connect(_on_show_player_toggled)
	show_site_button.toggled.connect(_on_show_site_toggled)


func _draw():
	var galaxy : Galaxy = get_tree().root.get_child(0).get_galaxy()
	var player : Agent = galaxy.player
	var location : TerrestrialLocation = player.get_terrestrial_location().get_root_terrestrial_location()
	
	var dimension = min(size.x, size.y) - MAP_MARGIN*2
	var map_position = Vector2.ZERO
	
	# HACK: This will only work if UI is in landscape
	map_position.x = (size.x - dimension) * 0.5
	map_position += Vector2(MAP_MARGIN, MAP_MARGIN)
	
	var map_rect = Rect2(map_position, Vector2(dimension, dimension))
	draw_rect(map_rect, MAP_COLOR)
	
	if show_player:
		draw_terrestrial_pip(map_rect, player.location_relative, location, PIP_COLOR_PLAYER)
	
	if show_sites:
		for child in location.get_children():
			if child is Site:
				draw_terrestrial_pip(map_rect, child.location_relative, location, PIP_COLOR_SITE)
				draw_terrestrial_label(map_rect, child.location_relative, location, child.get_node("Identity").title.capitalize())


func draw_terrestrial_pip(map : Rect2, pip : Vector2, location : TerrestrialLocation, color : Color):
	var draw_location = get_draw_location(map, pip, location)
	draw_circle(draw_location, PIP_RADIUS, color)


func draw_terrestrial_label(map : Rect2, pip : Vector2, location : TerrestrialLocation, label : String):
	var draw_location = get_draw_location(map, pip, location)
	draw_string(label_font, draw_location, label, HORIZONTAL_ALIGNMENT_LEFT, -1, LABEL_FONT_SIZE, LABEL_FONT_COLOR)


func get_draw_location(map : Rect2, relative_location : Vector2, location : TerrestrialLocation) -> Vector2:
	relative_location.y = -relative_location.y # Because North is positive for terrestrial locations
	
	var planet : Planet = location as Planet
	if planet != null:
		relative_location /= planet.get_size()
		relative_location *= map.size
	
	relative_location += map.position
	relative_location += map.size / 2
	
	return relative_location


func _on_turn_post(_turn : int):
	queue_redraw()


func _on_show_player_toggled(toggled_on : bool):
	show_player = toggled_on
	queue_redraw()


func _on_show_site_toggled(toggled_on : bool):
	show_sites = toggled_on
	queue_redraw()

extends PanelContainer


const MAP_COLOR : Color = Color.DIM_GRAY
const MAP_MARGIN = 10.0

const PIP_RADIUS = 2.5
const PIP_COLOR_PLAYER = Color.AQUA

var show_player : bool = true

@onready var show_player_button : CheckBox = $VBoxContainer/ShowPlayerButton


func _ready():
	var galaxy : Galaxy = get_tree().root.get_child(0).get_galaxy()
	galaxy.turn_post.connect(_on_turn_post)
	
	show_player_button.toggled.connect(_on_show_player_toggled)


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


func draw_terrestrial_pip(map : Rect2, pip : Vector2, location : TerrestrialLocation, color : Color):
	pip.y = -pip.y # Because North is positive for terrestrial locations
	
	var planet : Planet = location as Planet
	if planet != null:
		pip /= planet.get_size()
		pip *= map.size
	
	pip += map.position
	pip += map.size / 2
	
	draw_circle(pip, PIP_RADIUS, color)


func _on_turn_post(_turn : int):
	queue_redraw()


func _on_show_player_toggled(toggled_on : bool):
	show_player = toggled_on
	queue_redraw()

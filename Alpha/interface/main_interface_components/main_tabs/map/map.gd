extends PanelContainer


enum GridMode {
	NONE = 0,
	DISTANCE = 1,
}

const MAP_COLOR : Color = Color.DIM_GRAY
const MAP_MARGIN = 10.0

const PIP_RADIUS = 2.5
const PIP_COLOR_PLAYER = Color.AQUA
const PIP_COLOR_SITE = Color.BURLYWOOD

const LABEL_FONT_SIZE = 10
const LABEL_FONT_COLOR = Color.BLACK

const DISTANCE_UNIT : float = 5.0
const DISTANCE_LINE_COLOR : Color = Color(0, 0, 0, 0.5)

@export var label_font : Font

var show_player : bool = true
var show_survey : bool = true
var show_sites : bool = true
var grid_mode : GridMode = GridMode.DISTANCE

@onready var show_player_button : CheckBox = $VBoxContainer/ShowPlayerButton
@onready var show_survey_button : CheckBox = $VBoxContainer/ShowSurveyButton
@onready var show_site_button : CheckBox = $VBoxContainer/ShowSiteButton
@onready var show_grid_option : OptionButton = $VBoxContainer/HBoxContainer/ShowGridOption


func _ready():
	var galaxy : Galaxy = get_tree().root.get_child(0).get_galaxy()
	galaxy.turn_post.connect(_on_turn_post)
	
	show_player_button.toggled.connect(_on_show_player_toggled)
	show_survey_button.toggled.connect(_on_show_survey_toggled)
	show_site_button.toggled.connect(_on_show_site_toggled)
	show_grid_option.item_selected.connect(_on_show_grid_item_selected)


func _draw():
	var galaxy : Galaxy = get_tree().root.get_child(0).get_galaxy()
	var player : Agent = galaxy.player
	var location : TerrestrialLocation = player.get_terrestrial_location().get_root_terrestrial_location()
	var codex : Codex = player.codex
	
	var dimension = min(size.x, size.y) - MAP_MARGIN*2
	var map_position = Vector2.ZERO
	
	# HACK: This will only work if UI is in landscape
	map_position.x = (size.x - dimension) * 0.5
	map_position += Vector2(MAP_MARGIN, MAP_MARGIN)
	
	var map_rect = Rect2(map_position, Vector2(dimension, dimension))
	draw_rect(map_rect, MAP_COLOR)
	
	match grid_mode:
		GridMode.DISTANCE:
			draw_distance_grid(map_rect, location)
	
	if show_sites:
		for child in location.get_children():
			if child is Site:
				if not codex.knows_about(child, Codex.CodexDetails.LOCATION):
					continue
				var site_identity = child.get_node("Identity")
				draw_terrestrial_pip(map_rect, child.location_relative, location, PIP_COLOR_SITE)
				var site_label = Identity.get_title(site_identity, codex.knows_about(child, Codex.CodexDetails.TITLE))
				site_label = site_label.capitalize()
				draw_terrestrial_label(map_rect, child.location_relative, location, site_label)
	
	if show_player:
		draw_terrestrial_pip(map_rect, player.location_relative, location, PIP_COLOR_PLAYER)
	
	if show_survey:
		draw_terrestrial_distance_radius(map_rect, player.location_relative, location, player.get_detection_range())


func draw_terrestrial_pip(map : Rect2, pip : Vector2, location : TerrestrialLocation, color : Color):
	var draw_location = get_draw_location(map, pip, location)
	draw_circle(draw_location, PIP_RADIUS, color)


func draw_terrestrial_label(map : Rect2, pip : Vector2, location : TerrestrialLocation, label : String):
	var draw_location = get_draw_location(map, pip, location)
	draw_string(label_font, draw_location, label, HORIZONTAL_ALIGNMENT_LEFT, -1, LABEL_FONT_SIZE, LABEL_FONT_COLOR)


func draw_terrestrial_distance_radius(map : Rect2, position_relative : Vector2, location : TerrestrialLocation, radius : float):
	var map_position = get_draw_location(map, position_relative, location)
	var local_radius = radius * (map.size.x / location.get_size().x)
	draw_arc(map_position, local_radius, 0, TAU, 16, Color.RED)


func get_draw_location(map : Rect2, relative_location : Vector2, location : TerrestrialLocation) -> Vector2:
	relative_location.y = -relative_location.y # Because North is positive for terrestrial locations
	
	var planet : Planet = location as Planet
	if planet != null:
		relative_location /= planet.get_size()
		relative_location *= map.size
	
	relative_location += map.position
	relative_location += map.size / 2
	
	return relative_location


func draw_distance_grid(map : Rect2, location : TerrestrialLocation):
	var planet : Planet = location as Planet
	if planet == null:
		return
	
	var planet_size = planet.get_size()
	var width_offset = Vector2(map.size.x, 0)
	var height_offset = Vector2(0, map.size.y)
	
	for lat in range(DISTANCE_UNIT, planet_size.y, DISTANCE_UNIT):
		var lat_offset = Vector2(0, lat * (map.size.y / planet_size.y))
		draw_line(map.position + lat_offset, map.position + lat_offset + width_offset, DISTANCE_LINE_COLOR)
	for long in range(DISTANCE_UNIT, planet_size.x, DISTANCE_UNIT):
		var long_offset = Vector2(long * (map.size.x / planet_size.x), 0)
		draw_line(map.position + long_offset, map.position + long_offset + height_offset, DISTANCE_LINE_COLOR)


func _on_turn_post(_turn : int):
	queue_redraw()


func _on_show_player_toggled(toggled_on : bool):
	show_player = toggled_on
	queue_redraw()


func _on_show_survey_toggled(toggled_on : bool):
	show_survey = toggled_on
	queue_redraw()


func _on_show_site_toggled(toggled_on : bool):
	show_sites = toggled_on
	queue_redraw()


func _on_show_grid_item_selected(index : int):
	grid_mode = index as GridMode
	queue_redraw()

extends PanelContainer


const SECONDS_PER_MINUTE = 60
const MINUTES_PER_DEGREE = 60

const DEGREES_PER_LAT = 90
const DEGREES_PER_LONG = 180

const SECONDS_PER_DEGREE = SECONDS_PER_MINUTE * MINUTES_PER_DEGREE
const SECONDS_PER_LAT = SECONDS_PER_DEGREE * DEGREES_PER_LAT
const SECONDS_PER_LONG = SECONDS_PER_DEGREE * DEGREES_PER_LONG

const H_BREAK = "    |    "

@onready var location_name : Label = $"CenterContainer/HBoxContainer/LocationName"


func _ready():
	var galaxy : Galaxy = get_tree().root.get_child(0).get_galaxy()
	galaxy.turn_post.connect(_on_turn_post)
	_on_turn_post(galaxy.turn)


func get_player() -> Agent:
	var galaxy : Galaxy = get_tree().root.get_child(0).get_galaxy()
	return galaxy.player


func update_location():
	var player = get_player()
	var location = player.get_parent()
	
	var identity = player.get_parent().get_identity()
	var text = "planet "
	var codex : Codex = player.codex
	text += player.get_parent().name if identity == null else Identity.get_title(identity, codex.knows_title(location))
	text = text.capitalize()
	
	if location is Planet:
		text += H_BREAK + planet_local_location_string(player, location as Planet)
		text += H_BREAK + str(player.location_relative)
	
	location_name.text = text


@warning_ignore("integer_division")
func planet_local_location_string(agent : Agent, planet : Planet) -> String:
	var format_string = "{lat_deg}° {lat_min}' {lat_sec}\" {lat_card}, {long_deg}° {long_min}' {long_sec}\" {long_card}"
	var location = agent.location_relative / (planet.get_size() / 2)
	
	var lat_card = "North" if location.y >= 0 else "South"
	var long_card = "East" if location.x >= 0 else "West"
	
	var lat_running : int = abs(location.y) * SECONDS_PER_LAT
	var long_running : int = abs(location.x) * SECONDS_PER_LONG
	
	var lat_seconds : int = lat_running % SECONDS_PER_MINUTE
	lat_running -= lat_seconds
	var lat_minutes : int = lat_running % SECONDS_PER_DEGREE
	lat_running -= lat_minutes
	lat_minutes /= SECONDS_PER_MINUTE
	var lat_degrees : int = lat_running / SECONDS_PER_DEGREE
	
	var long_seconds : int = long_running % SECONDS_PER_MINUTE
	long_running -= long_seconds
	var long_minutes : int = long_running % SECONDS_PER_DEGREE
	long_running -= long_minutes
	long_minutes /= SECONDS_PER_MINUTE
	var long_degrees : int = long_running / SECONDS_PER_DEGREE
	
	return format_string.format({
		"lat_sec" : lat_seconds,
		"lat_min" : lat_minutes,
		"lat_deg" : lat_degrees,
		"lat_card" : lat_card,
		
		"long_sec" : long_seconds,
		"long_min" : long_minutes,
		"long_deg" : long_degrees,
		"long_card" : long_card,
	})


func _on_turn_post(_turn):
	update_location()

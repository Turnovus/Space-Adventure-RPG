extends PanelContainer


const TURNS_PER_HOUR = 10
const TURNS_PER_DAY = TURNS_PER_HOUR * 24
const TURNS_PER_YEAR = TURNS_PER_DAY * 100
const ZERO_DAY = 1
const ZERO_YEAR = 1

const LIGHT_LEVEL_DAY = 0.5
const LIGHT_LEVEL_NIGHT = 0.1

@export var sun_icon : Texture2D
@export var moon_icon : Texture2D
@export var sunrise_icon : Texture2D
@export var sunset_icon : Texture2D

@onready var universe_clock: Label = $TimePanelInner/VBoxContainer/Universe/UniverseClock
@onready var local_clock: Label = $TimePanelInner/VBoxContainer/Local/LocalClock
@onready var local_icon : TextureRect = $TimePanelInner/VBoxContainer/Local/LocalIcon


func _ready():
	var galaxy : Galaxy = get_tree().root.get_child(0).get_galaxy()
	galaxy.turn_post.connect(_on_turn_post)
	_on_turn_post(galaxy.turn)


@warning_ignore("integer_division")
func _on_turn_post(turn:int):
	var galaxy : Galaxy = get_tree().root.get_child(0).get_galaxy()
	var player : Agent = galaxy.player
	
	var turn_running: int = turn
	var turn_minutes: int = turn_running % TURNS_PER_HOUR
	turn_running -= turn_minutes
	var minutes: int = turn_minutes * (60 / TURNS_PER_HOUR)
	
	var turn_hours = turn_running % TURNS_PER_DAY
	turn_running -= turn_hours
	var hours: int = turn_hours / TURNS_PER_HOUR
	
	var turn_days = turn_running % TURNS_PER_YEAR
	turn_running -= turn_days
	var days: int = turn_days / TURNS_PER_DAY
	
	var years:int = turn_running / TURNS_PER_YEAR
	
	universe_clock.text = ""
	
	universe_clock.text += "Year " + str(ZERO_YEAR + years)
	universe_clock.text += ", Day " + str(ZERO_DAY + days)
	
	universe_clock.text += " - "
	
	if hours < 10:
		universe_clock.text += "0"
	universe_clock.text += str(hours)
	
	universe_clock.text += ":"
	if minutes < 10:
		universe_clock.text += "0"
	universe_clock.text += str(minutes)
	
	var location = player.get_terrestrial_location()
	if location != null:
		local_time_terrestrial(player, location)


func local_time_terrestrial(player : Agent, location : TerrestrialLocation):
	var local_time = location.time_of_day_at(player.location_relative)
	var total_minutes = 1440.0 * local_time
	
	var minutes = int(total_minutes) % 60
	var hours = int((total_minutes - minutes) / 60.0)
	
	local_clock.text = ""
	if hours < 10:
		local_clock.text += "0"
	local_clock.text += str(hours)
	local_clock.text += ":"
	if minutes < 10:
		local_clock.text += "0"
	local_clock.text += str(minutes)
	
	var light = location.light_level_at(player.location_relative)
	local_clock.text += " - "
	if light < LIGHT_LEVEL_NIGHT:
		local_clock.text += "Night"
		local_icon.texture = moon_icon
	elif light > LIGHT_LEVEL_DAY:
		local_clock.text += "Day"
		local_icon.texture = sun_icon
	elif local_time < 0.5:
		local_clock.text += "Dawn"
		local_icon.texture = sunrise_icon
	else:
		local_clock.text += "Dusk"
		local_icon.texture = sunset_icon

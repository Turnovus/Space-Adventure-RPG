extends PanelContainer


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
	
	universe_clock.text = DateUtil.get_full_date_string(turn)
	
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
	
	local_clock.text = try_append_year(local_clock.text, location, player)
	
	local_clock.text += " - Light x"
	local_clock.text += str(snapped(light, 0.01))


func try_append_year(text : String, location : TerrestrialLocation, player : Agent) -> String:
	var planet = location.get_root_terrestrial_location() as Planet
	if planet == null:
		return text
	
	var date = planet.year_progress_percent()
	if player.location_relative.y >= 0:
		date = fmod(date + 0.5, 1)
	text += " - "
	if date < 0.125:
		text += "Fall"
	elif date < 0.375:
		text += "Winter"
	elif date < 0.625:
		text += "Spring"
	elif date < 0.875:
		text += "Summer"
	else:
		text += "Fall"
	
	return text

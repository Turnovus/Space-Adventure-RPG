class_name Site
extends TerrestrialLocation


var inactive_turns_to_expire : int = -1
var last_turn_maintained : int


func setup(location : Vector2, expiration_turns = -1):
	location_relative = location
	inactive_turns_to_expire = expiration_turns


func get_detection_range_factor() -> float:
	return 1.0


func _turn_action(turn : int):
	if inactive_turns_to_expire < 0:
		return
	
	for child in get_children():
		if child is Agent:
			last_turn_maintained = turn
			return
	
	if turn > inactive_turns_to_expire + last_turn_maintained:
		#TODO: Handle child nodes
		queue_free()

class_name TerrestrialLocation
extends Entity


@export_subgroup("Entry")
@export var entry_action : PackedScene
@export var check_relative_distance : bool
@export var max_entry_distance : float


func get_shortest_distance(relative_position_a : Vector2, relative_position_b : Vector2) -> float:
	return relative_position_a.distance_to(relative_position_b)


func get_root_terrestrial_location() -> TerrestrialLocation:
	var parent = get_parent()
	if parent is TerrestrialLocation:
		return parent.get_root_terrestrial_location()
	
	return self


func time_of_day_at(relative_location : Vector2) -> float:
	var parent = get_parent() as TerrestrialLocation
	if parent == null:
		return 1
	
	return parent.time_of_day_at(relative_location)


func light_level_at(relative_location : Vector2) -> float:
	var parent = get_parent() as TerrestrialLocation
	if parent == null:
		return 1
	
	return parent.light_level_at(relative_location)

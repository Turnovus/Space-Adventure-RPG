class_name TerrestrialLocation
extends Entity


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

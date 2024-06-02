extends Control


signal galaxy_begin


func get_galaxy() -> Galaxy:
	# Broken up in case we decide to do something interesting with save/load
	# states or something later.
	var galaxy = get_node("Galaxy")
	
	if galaxy == null:
		print("Tried to read null galaxy.")
	
	return galaxy

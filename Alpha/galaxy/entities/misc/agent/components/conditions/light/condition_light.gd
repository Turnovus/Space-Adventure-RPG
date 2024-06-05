extends Condition


func update(agent : Agent):
	degree = 0
	
	var location : TerrestrialLocation = agent.get_terrestrial_location()
	if location == null:
		return
	
	var light = location.light_level_at(agent.location_relative)
	# HACK
	if light > 0.2:
		degree = 1
	if light > 0.4:
		degree = 2
	if light > 0.6:
		degree = 3

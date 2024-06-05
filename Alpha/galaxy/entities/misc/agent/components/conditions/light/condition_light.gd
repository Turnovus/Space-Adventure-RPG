extends Condition


func update(agent : Agent):
	degree = 0
	
	var planet : Planet = agent.get_parent() as Planet
	if planet == null:
		return
	
	var light = planet.light_level_at(agent.location_relative)
	# HACK
	if light > 0.2:
		degree = 1
	if light > 0.4:
		degree = 2
	if light > 0.6:
		degree = 3

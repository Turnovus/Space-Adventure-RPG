class_name ActionComponentForage
extends ActionComponent


@export var forage_group : ForageGroup


func action_possible(agent : Agent) -> bool:
	var biome : Biome = get_agent_biome(agent)
	return false if biome == null else can_forage(biome)


func can_forage(biome : Biome) -> bool:
	return biome.can_forage(forage_group)


func get_agent_biome(agent : Agent) -> Biome:
	var location : TerrestrialLocation = agent.get_terrestrial_location()
	if location == null:
		return null
	return location.get_biome_at(agent.location_relative)


func turn_action(agent : Agent, potency : float):
	var biome : Biome = get_agent_biome(agent)
	if not can_forage(biome):
		return
	
	var planet : Planet = agent.get_terrestrial_location() as Planet
	if planet == null:
		return
	
	while true:
		var chance : float = planet.biomes.get_forage_chance_at(agent.location_relative, forage_group, potency)
		print(chance)
		if chance <= 0:
			break
		
		var success : bool = randf() < chance
		if not success:
			break

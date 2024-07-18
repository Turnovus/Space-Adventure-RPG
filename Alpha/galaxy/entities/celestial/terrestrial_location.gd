class_name TerrestrialLocation
extends Entity


@export_subgroup("Entry")
@export var entry_action : PackedScene
@export var check_relative_distance : bool
@export var max_entry_distance : float


func get_shortest_distance(relative_position_a : Vector2, relative_position_b : Vector2) -> float:
	return relative_position_a.distance_to(relative_position_b)


func get_outgoing_actions_for(agent_requesting : Agent) -> Array[Action]:
	var actions : Array[Action] = super(agent_requesting)
	#HACK : Remove this if support for sibling-to-sibling actions is added
	for child in get_children():
		var location = child as TerrestrialLocation
		if location == null or location.entry_action == null:
			continue
		
		if location.check_relative_distance:
			var location_position = location.location_relative
			var agent_position = agent_requesting.location_relative
			if get_shortest_distance(location_position, agent_position) > location.max_entry_distance:
				continue
		
		var action = location.issue_entry_action(agent_requesting)
		actions.append(action)
	
	return actions


func issue_entry_action(agent : Agent) -> Action:
	var action : Action = null
	for child in get_children():
		if child.scene_file_path == entry_action.resource_path:
			action = child as Action
	if action == null:
		action = entry_action.instantiate() as Action
		action.issuer = self
		add_child(action)
	
	action.label = "Enter " + Identity.get_title(get_identity(), agent.codex.knows_title(self)).capitalize()
	return action


func get_root_terrestrial_location() -> TerrestrialLocation:
	var parent = get_parent()
	if parent is TerrestrialLocation:
		return parent.get_root_terrestrial_location()
	
	return self


func get_biome_at(position : Vector2) -> Biome:
	var parent : TerrestrialLocation = get_parent() as TerrestrialLocation
	return null if parent == null else parent.get_biome_at(position)


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

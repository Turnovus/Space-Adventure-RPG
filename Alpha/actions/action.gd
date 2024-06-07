extends Node
class_name Action


@export var icon : Texture2D
@export var label : String
@export var base_potency : float = 1


func get_components() -> Array[ActionComponent]:
	var components : Array[ActionComponent] = []
	for child in get_children():
		var component = child as ActionComponent
		if component != null:
			components.append(component)
	return components


func get_physical_point_cost() -> int:
	var cost = 0
	for component in get_components():
		cost = component.affect_physical_point_cost(cost)
	return cost


func get_mental_point_cost() -> int:
	var cost = 0
	for component in get_components():
		cost = component.affect_mental_point_cost(cost)
	return cost


func get_potency() -> float:
	var potency = base_potency
	for component in get_components():
		potency = component.affect_potency(potency)
	return potency


func is_possible_for(agent : Agent) -> bool:
	if len(agent.actions_this_turn) > 0:
		if agent.unallocated_mental_points() <= get_mental_point_cost():
			return false
		if agent.unallocated_physical_points() <= get_physical_point_cost():
			return false
	
	return true


func is_exclusive_with(other : Action) -> bool:
	if other.scene_file_path == scene_file_path:
		return true
	
	return false


func action_turn(_agent : Agent):
	pass

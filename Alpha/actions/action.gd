extends Node
class_name Action


@export var label : String = ""


func physical_point_cost() -> int:
	var points = 0
	
	for child in get_children(true):
		if child is PointCostResolverBase:
			points += child.physical_point_cost()
	
	return points


func mental_point_cost() -> int:
	var points = 0
	
	for child in get_children(true):
		if child is PointCostResolverBase:
			points += child.mental_point_cost()
	
	return points


func get_full_label() -> String:
	return label


func action_resolve(agent : Agent):
	pass


func do_continue() -> bool:
	return false


func is_possible_for(agent : Agent) -> bool:
	return true

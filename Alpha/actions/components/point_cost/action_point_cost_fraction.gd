class_name ActionComponentPointCostFraction
extends ActionComponent


@export var physical_points_percent : float = 0
@export var mental_points_percent : float = 0

@export_subgroup("potency")
@export var physical_affects_potency : bool
@export var base_physical_points : int
@export var mental_affects_potency : bool
@export var base_mental_points : int


func affect_physical_point_cost(initial_points : int, agent : Agent) -> int:
	return initial_points + _get_physical_point_cost(agent)


func affect_mental_point_cost(initial_points : int, agent : Agent) -> int:
	return initial_points + _get_mental_point_cost(agent)


func affect_potency(initial_potency : float, agent : Agent) -> float:
	var potency : float = initial_potency
	
	if physical_affects_potency:
		potency *= float(_get_physical_point_cost(agent)) / base_physical_points
	if mental_affects_potency:
		potency *= float(_get_mental_point_cost(agent)) / base_mental_points
	
	return potency


func _get_physical_point_cost(agent : Agent) -> int:
	return int(agent.max_physical_points() * physical_points_percent)


func _get_mental_point_cost(agent : Agent) -> int:
	return int(agent.max_mental_points() * mental_points_percent)

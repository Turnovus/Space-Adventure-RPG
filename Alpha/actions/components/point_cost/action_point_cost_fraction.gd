extends ActionComponent
class_name ActionComponentPointCostFraction


@export var physical_points_percent : float = 0
@export var mental_points_percent : float = 0


func affect_physical_point_cost(initial_points : int, agent : Agent) -> int:
	return initial_points + int(agent.max_physical_points() * physical_points_percent)


func affect_mental_point_cost(initial_points : int, agent : Agent) -> int:
	return initial_points + int(agent.max_mental_points() * mental_points_percent)

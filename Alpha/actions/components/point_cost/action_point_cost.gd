extends ActionComponent
class_name ActionComponentPointCost


@export var add_cost_physical : int = 0
@export var add_cost_mental : int = 0


func affect_physical_point_cost(initial_cost : int) -> int:
	return initial_cost + add_cost_physical


func affect_mental_point_cost(initial_cost : int) -> int:
	return initial_cost + add_cost_mental

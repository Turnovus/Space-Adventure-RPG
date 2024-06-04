extends PointCostResolverBase
class_name PointCostResolverMaximum


@export var physical_factor : float = 0
@export var mental_factor : float = 0


@warning_ignore("narrowing_conversion")
func physical_point_cost(agent : Agent) -> int:
	return agent.max_physical_points() * physical_factor


@warning_ignore("narrowing_conversion")
func mental_point_cost(agent : Agent) -> int:
	return agent.max_mental_points() * mental_factor

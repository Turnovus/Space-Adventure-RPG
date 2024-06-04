extends PointCostResolverBase
class_name PointCostResolverSimple


@export var physical_points : int = 0
@export var mental_points : int = 0


func physical_point_cost(_agent : Agent) -> int:
	return physical_points


func mental_point_cost(_agent : Agent) -> int:
	return mental_points

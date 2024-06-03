extends Entity
class_name Agent


const BASE_POINTS = 20

var is_player: bool = false


func max_physical_points() -> int:
	return BASE_POINTS


func max_mental_points() -> int:
	return BASE_POINTS


func unallocated_physical_points() -> int:
	return BASE_POINTS


func unallocated_mental_points() -> int:
	return BASE_POINTS

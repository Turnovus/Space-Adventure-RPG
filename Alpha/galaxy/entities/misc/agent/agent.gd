extends Entity
class_name Agent


const BASE_POINTS = 20

@onready var conditions = $ConditionManager

var is_player: bool = false
var actions_this_turn : Array[Action]


func max_physical_points() -> int:
	return BASE_POINTS


func max_mental_points() -> int:
	return BASE_POINTS


func unallocated_physical_points() -> int:
	var points = max_physical_points()
	for action in actions_this_turn:
		points -= action.physical_point_cost(self)
	return points


func unallocated_mental_points() -> int:
	var points = max_mental_points()
	for action in actions_this_turn:
		points -= action.mental_point_cost(self)
	return points


func _turn_action():
	for action in actions_this_turn:
		action.action_resolve(self)
	
	conditions.update(self)

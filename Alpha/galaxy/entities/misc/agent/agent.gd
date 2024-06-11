extends Entity
class_name Agent


const BASE_POINTS = 20

@export var physical_point_stat : Stat
@export var mental_point_stat : Stat
@export var learning_stat : Stat

@onready var conditions : ConditionManager = $ConditionManager
@onready var stats : StatManager = $StatManager
@onready var knowledge : KnowledgeTracker = $KnowledgeTracker

var is_player: bool = false
var actions_this_turn : Array[Action]


@warning_ignore("narrowing_conversion")
func max_physical_points() -> int:
	return physical_point_stat.get_current_potency()


@warning_ignore("narrowing_conversion")
func max_mental_points() -> int:
	return mental_point_stat.get_current_potency()


func unallocated_physical_points() -> int:
	var points = max_physical_points()
	for action in actions_this_turn:
		points -= action.get_physical_point_cost(self)
	return points


func unallocated_mental_points() -> int:
	var points = max_mental_points()
	for action in actions_this_turn:
		points -= action.get_mental_point_cost(self)
	return points


func get_terrestrial_location() -> TerrestrialLocation:
	return get_parent() as TerrestrialLocation


func _turn_action():
	for action in actions_this_turn:
		action.action_turn(self)
	
	conditions.update(self)
	
	var unspent_mental = unallocated_mental_points()
	if unspent_mental > 0:
		knowledge.do_random_learning(unspent_mental, learning_stat.get_current_potency())

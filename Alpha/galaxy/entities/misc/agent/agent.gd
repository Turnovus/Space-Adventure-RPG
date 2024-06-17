class_name Agent
extends Entity


const BASE_POINTS = 20

@export var physical_point_stat : Stat
@export var mental_point_stat : Stat
@export var learning_stat : Stat

var is_player: bool = false
var actions_this_turn : Array[Action]

@onready var conditions : ConditionManager = $ConditionManager
@onready var stats : StatManager = $StatManager
@onready var knowledge : KnowledgeTracker = $KnowledgeTracker
@onready var codex : Codex = $Codex


func _ready():
	var galaxy : Galaxy = get_tree().root.get_child(0).get_galaxy()
	galaxy.turn_end.connect(_on_turn_end)


@warning_ignore("narrowing_conversion")
func max_physical_points() -> int:
	return physical_point_stat.get_current_potency(self)


@warning_ignore("narrowing_conversion")
func max_mental_points() -> int:
	return mental_point_stat.get_current_potency(self)


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


func get_detection_range() -> float:
	#TODO: Detection stat
	return 15


func _turn_action(_turn : int):
	for action in actions_this_turn:
		action.action_turn(self)
	
	conditions.update(self)
	
	var unspent_mental = unallocated_mental_points()
	if unspent_mental > 0:
		knowledge.do_random_learning(unspent_mental, learning_stat.get_current_potency(self))


func _on_turn_end(_turn : int):
	var actions_next_turn : Array[Action] = []
	
	for action in actions_this_turn:
		if action.sustain_action(self):
			actions_next_turn.append(action)
	
	actions_this_turn = actions_next_turn
	actions_next_turn = []

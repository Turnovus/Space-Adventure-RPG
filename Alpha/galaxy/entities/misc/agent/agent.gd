class_name Agent
extends Entity


const BASE_POINTS = 20

@export_category("stats")
@export var physical_point_stat : Stat
@export var mental_point_stat : Stat
@export var learning_stat : Stat
@export var survey_range_stat : Stat

var is_player: bool = false

@onready var conditions : ConditionManager = $ConditionManager
@onready var stats : StatManager = $StatManager
@onready var knowledge : KnowledgeTracker = $KnowledgeTracker
@onready var codex : Codex = $Codex
@onready var skills : SkillTracker = $SkillTracker
@onready var actions : ActionTracker = $ActionTracker


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
	# TODO: Subtract point costs from active actions
	return points


func unallocated_mental_points() -> int:
	var points = max_mental_points()
	# TODO: Subtract point costs from active actions
	return points


func get_terrestrial_location() -> TerrestrialLocation:
	return get_parent() as TerrestrialLocation


func get_detection_range() -> float:
	return survey_range_stat.get_current_potency(self)


func get_doable_actions() -> Array[ActionDoer]:
	# TODO: Validate action eligibility
	return get_parent().get_action_doers()


func _turn_action(_turn : int):
	print_orphan_nodes()
	#TODO: Actions
	
	conditions.update(self)
	
	var unspent_mental = unallocated_mental_points()
	if unspent_mental > 0:
		knowledge.do_random_learning(unspent_mental, learning_stat.get_current_potency(self))


func _on_turn_end(_turn : int):
	# TODO: Re-validate selected actions
	pass

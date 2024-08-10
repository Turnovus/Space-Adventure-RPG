@icon("res://assets/textures/body/person.svg")
class_name Agent
extends Entity


const BASE_POINTS = 20

@export_subgroup("stats")
@export var physical_point_stat : Stat
@export var mental_point_stat : Stat
@export var learning_stat : Stat
@export var survey_range_stat : Stat
@export_subgroup("crafting")
@export var crafting_root : CraftingGroup

var is_player: bool = false

@onready var conditions : ConditionManager = $ConditionManager
@onready var stats : StatManager = $StatManager
@onready var knowledge : KnowledgeTracker = $KnowledgeTracker
@onready var codex : Codex = $Codex
@onready var skills : SkillTracker = $SkillTracker
@onready var actions : ActionTracker = $ActionTracker
@onready var inventory : Inventory = $Inventory


@warning_ignore("narrowing_conversion")
func max_physical_points() -> int:
	return physical_point_stat.get_current_potency(self)


@warning_ignore("narrowing_conversion")
func max_mental_points() -> int:
	return mental_point_stat.get_current_potency(self)


func get_terrestrial_location() -> TerrestrialLocation:
	return get_parent() as TerrestrialLocation


func get_detection_range() -> float:
	return survey_range_stat.get_current_potency(self)


func _turn_action(turn : int):
	actions.do_turn()
	actions.validate_actions()
	
	conditions.update(self)
	
	var unspent_mental = max_mental_points() - actions.allocated_mental_points()
	if unspent_mental > 0:
		knowledge.do_random_learning(unspent_mental, learning_stat.get_current_potency(self))
	
	inventory.do_turn(turn)

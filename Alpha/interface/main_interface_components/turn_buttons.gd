extends VBoxContainer


@export_multiline var tooltip_advance_turn : String
@export_multiline var tooltip_points_overallocated : String

var galaxy: Galaxy

@onready var turn_button = $"TurnButton"
@onready var action_button = $"ActionButton"


func _ready():
	galaxy = get_tree().root.get_child(0).get_galaxy()
	turn_button.pressed.connect(_on_turn_button_pressed)
	galaxy.player.actions.actions_changed.connect(_on_player_actions_changed)
	galaxy.player_points_reallocated.connect(_on_player_actions_changed)
	_on_player_actions_changed()


func _on_turn_button_pressed():
	galaxy.request_turn_advance()


func _on_player_actions_changed():
	var overallocated = player_points_overallocated()
	turn_button.disabled = overallocated
	turn_button.tooltip_text = tooltip_advance_turn if not overallocated else tooltip_points_overallocated


func player_points_overallocated() -> bool:
	var player = galaxy.player
	if player.actions.count_actions() <= 1:
		return false
	
	var over_mental = player.actions.allocated_mental_points() > player.max_mental_points()
	var over_physical = player.actions.allocated_physical_points() > player.max_physical_points()
	return over_mental or over_physical

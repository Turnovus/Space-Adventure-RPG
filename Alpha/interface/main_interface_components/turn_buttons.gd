extends VBoxContainer


@export_multiline var tooltip_advance_turn : String
@export_multiline var tooltip_points_overallocated : String
@export_multiline var tooltip_action_impossible : String

var galaxy: Galaxy

@onready var turn_button : Button = $"TurnButton"
@onready var action_button : Button = $"ActionButton"


func _ready():
	galaxy = await ReferenceSingleton.get_galaxy()
	turn_button.pressed.connect(_on_turn_button_pressed)
	galaxy.player.actions.actions_changed.connect(_on_player_actions_changed)
	galaxy.player.actions.activities_changed.connect(_on_player_actions_changed)
	galaxy.player_points_reallocated.connect(_on_player_actions_changed)
	_on_player_actions_changed()


func _on_turn_button_pressed():
	galaxy.request_turn_advance()


func _on_player_actions_changed():
	if  player_points_overallocated():
		turn_button.disabled = true
		turn_button.tooltip_text = tooltip_points_overallocated
		return
	
	if player_has_impossible_action():
		turn_button.disabled = true
		turn_button.tooltip_text = tooltip_action_impossible
		return
	
	turn_button.disabled = false
	turn_button.tooltip_text = tooltip_advance_turn


func player_points_overallocated() -> bool:
	var player = galaxy.player
	if player.actions.count_actions() <= 1:
		return false
	
	var over_mental = player.actions.allocated_mental_points() > player.max_mental_points()
	var over_physical = player.actions.allocated_physical_points() > player.max_physical_points()
	return over_mental or over_physical


func player_has_impossible_action() -> bool:
	var player = galaxy.player
	for action : Action in player.actions.get_actions():
		if not action.is_possible_for(player):
			return true
	return false

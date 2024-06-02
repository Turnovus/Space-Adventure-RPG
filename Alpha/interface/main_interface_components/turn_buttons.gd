extends VBoxContainer


@onready var turn_button = $"TurnButton"
@onready var action_button = $"ActionButton"

var galaxy: Galaxy


func _ready():
	galaxy = get_tree().root.get_child(0).get_galaxy()
	turn_button.pressed.connect(_on_turn_button_pressed)


func _on_turn_button_pressed():
	galaxy.request_turn_advance()

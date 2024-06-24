class_name ActionListing
extends PanelContainer


enum ActionListingMode {
	ADD,
	REMOVE,
}

var doer : ActionDoer
var mode : ActionListingMode = ActionListingMode.ADD

@onready var action_icon : TextureRect = $VBoxContainer/TitleRow/ActionIcon
@onready var action_label : Label = $VBoxContainer/TitleRow/ActionLabel

@onready var button : Button = $VBoxContainer/TitleRow/Button


func _ready():
	button.pressed.connect(_on_button_pressed)


func update():
	if doer.action.icon != null:
		action_icon.texture = doer.action.icon
	action_label.text = doer.action.base_label
	
	match mode:
		ActionListingMode.ADD:
			button.text = "Add"
		ActionListingMode.REMOVE:
			button.text = "X"


func _on_button_pressed():
	var galaxy : Galaxy = get_tree().root.get_child(0).get_galaxy()
	match mode:
		ActionListingMode.ADD:
			doer.reparent(galaxy.player.actions)
		ActionListingMode.REMOVE:
			doer.queue_free()
	galaxy.player_actions_changed.emit()
	queue_free()

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

@onready var point_space : Control = $VBoxContainer/TitleRow/PointSpace
@onready var physical_icon : TextureRect = $VBoxContainer/TitleRow/PhysicalIcon
@onready var physical_readout : Label = $VBoxContainer/TitleRow/PhysicalCost
@onready var mental_icon : TextureRect = $VBoxContainer/TitleRow/MentalIcon
@onready var mental_readout : Label = $VBoxContainer/TitleRow/MentalCost


func _ready():
	button.pressed.connect(_on_button_pressed)


func update():
	var galaxy : Galaxy = get_tree().root.get_child(0).get_galaxy()
	var player : Agent = galaxy.player
	var parameters : Dictionary =  doer.get_parameters(player)
	
	if doer.action.icon != null:
		action_icon.texture = doer.action.icon
	action_label.text = doer.action.base_label
	
	match mode:
		ActionListingMode.ADD:
			button.text = "Add"
		ActionListingMode.REMOVE:
			button.text = "X"
	
	var physical = parameters[Action.PARAMETER_POINT_COST_PHYSICAL]
	var mental = parameters[Action.PARAMETER_POINT_COST_MENTAL]
	
	point_space.visible = (physical > 0 or mental > 0)
	
	physical_readout.text = str(physical)
	physical_readout.visible = (physical > 0)
	physical_icon.visible = (physical > 0)
	
	mental_readout.text = str(mental)
	mental_readout.visible = (mental > 0)
	mental_icon.visible = (mental > 0)


func _on_button_pressed():
	var galaxy : Galaxy = get_tree().root.get_child(0).get_galaxy()
	match mode:
		ActionListingMode.ADD:
			doer.reparent(galaxy.player.actions)
		ActionListingMode.REMOVE:
			# We need to remove it from the action tracker because it won't be
			# freed by the time the action list's update method is called,
			# which will cause it think the action is still active.
			galaxy.player.actions.remove_child(doer)
			doer.queue_free()
	galaxy.player_actions_changed.emit()
	queue_free()

class_name ActionListing
extends PanelContainer


var doer : ActionDoer

@onready var action_icon : TextureRect = $VBoxContainer/TitleRow/ActionIcon
@onready var action_label : Label = $VBoxContainer/TitleRow/ActionLabel


func update():
	if doer.action.icon != null:
		action_icon.texture = doer.action.icon
	action_label.text = doer.action.base_label

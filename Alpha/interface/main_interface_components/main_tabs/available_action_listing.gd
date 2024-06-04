extends Button


var action : Action


func _ready():
	pressed.connect(_on_pressed)


func set_action(new_action : Action):
	action = new_action
	text = action.get_full_label()
	
	if action.icon != null:
		icon = action.icon


func _on_pressed():
	var galaxy : Galaxy = get_tree().root.get_child(0).get_galaxy()
	galaxy.try_add_player_action(action)

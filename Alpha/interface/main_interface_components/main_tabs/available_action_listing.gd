extends HBoxContainer


@onready var button : Button = $Button
@onready var physical_icon : TextureRect = $PhysicalIcon
@onready var mental_icon : TextureRect = $MentalIcon
@onready var physical_count : Label = $PhysicalCount
@onready var mental_count : Label = $MentalCount

var action : Action


func _ready():
	button.pressed.connect(_on_pressed)


func set_action(new_action : Action):
	var galaxy : Galaxy = get_tree().root.get_child(0).get_galaxy()
	var player = galaxy.player
	
	action = new_action
	button.text = action.get_full_label()
	
	if action.icon != null:
		button.icon = action.icon
	
	var physical = action.physical_point_cost(player)
	if physical != 0:
		physical_count.text = str(physical)
	else:
		physical_icon.hide()
		physical_count.hide()
	
	var mental = action.mental_point_cost(player)
	if mental != 0:
		mental_count.text = str(mental)
	else:
		mental_icon.hide()
		mental_count.hide()


func _on_pressed():
	var galaxy : Galaxy = get_tree().root.get_child(0).get_galaxy()
	galaxy.try_add_player_action(action)

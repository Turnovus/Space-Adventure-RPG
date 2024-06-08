extends PanelContainer


@onready var physical_readout = $"CenterContainer/VBoxContainer/PhysicalRow/PhysicalReadout"
@onready var mental_readout = $"CenterContainer/VBoxContainer/MentalRow/MentalReadout"


func _ready():
	var galaxy : Galaxy = get_tree().root.get_child(0).get_galaxy()
	galaxy.player_actions_changed.connect(_on_player_actions_changed)
	galaxy.player_points_reallocated.connect(_on_player_actions_changed)
	_on_player_actions_changed()


func get_player() -> Agent:
	var galaxy : Galaxy = get_tree().root.get_child(0).get_galaxy()
	return galaxy.player


func _on_player_actions_changed():
	var player : Agent = get_player()
	var max_phys = player.max_physical_points()
	var max_ment = player.max_mental_points()
	
	physical_readout.text = "{used}/{max}".format({
		"used" : max_phys - player.unallocated_physical_points(),
		"max" : max_phys,
	})
	mental_readout.text  = "{used}/{max}".format({
		"used" : max_ment - player.unallocated_mental_points(),
		"max" : max_ment,
	})

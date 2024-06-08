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
	var used_phys = max_phys - player.unallocated_physical_points()
	var used_ment = max_ment - player.unallocated_mental_points()
	
	if used_phys > max_phys:
		if len(player.actions_this_turn) > 1:
			physical_readout.set("theme_override_colors/font_color", Color.RED)
		else:
			physical_readout.set("theme_override_colors/font_color", Color.ORANGE)
	else:
		physical_readout.set("theme_override_colors/font_color", Color.WHITE)
	
	if used_ment > max_ment:
		if len(player.actions_this_turn) > 1:
			mental_readout.set("theme_override_colors/font_color", Color.RED)
		else:
			mental_readout.set("theme_override_colors/font_color", Color.ORANGE)
	else:
		mental_readout.set("theme_override_colors/font_color", Color.WHITE)
	
	physical_readout.text = "{used}/{max}".format({
		"used" : used_phys,
		"max" : max_phys,
	})
	mental_readout.text  = "{used}/{max}".format({
		"used" : used_ment,
		"max" : max_ment,
	})

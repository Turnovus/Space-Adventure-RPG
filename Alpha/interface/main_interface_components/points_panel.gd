extends PanelContainer


@onready var physical_readout = $"CenterContainer/VBoxContainer/PhysicalRow/PhysicalReadout"
@onready var mental_readout = $"CenterContainer/VBoxContainer/MentalRow/MentalReadout"


func _ready():
	var galaxy : Galaxy = await ReferenceSingleton.get_galaxy()
	galaxy.player.actions.actions_changed.connect(_on_player_actions_changed)
	galaxy.player_points_reallocated.connect(_on_player_actions_changed)
	_on_player_actions_changed()


func _on_player_actions_changed():
	var player : Agent = await ReferenceSingleton.get_player()
	var max_phys = player.max_physical_points()
	var max_ment = player.max_mental_points()
	var used_phys = player.actions.allocated_physical_points()
	var used_ment = player.actions.allocated_mental_points()
	
	if used_phys > max_phys:
		if player.actions.count_actions() > 1:
			physical_readout.set("theme_override_colors/font_color", GameColorUtil.COLOR_BAD_READABLE)
		else:
			physical_readout.set("theme_override_colors/font_color", GameColorUtil.COLOR_WARN_READABLE)
	else:
		physical_readout.set("theme_override_colors/font_color", GameColorUtil.COLOR_NORMAL)
	
	if used_ment > max_ment:
		if player.actions.count_actions() > 1:
			mental_readout.set("theme_override_colors/font_color", GameColorUtil.COLOR_BAD_READABLE)
		else:
			mental_readout.set("theme_override_colors/font_color", GameColorUtil.COLOR_WARN_READABLE)
	else:
		mental_readout.set("theme_override_colors/font_color", GameColorUtil.COLOR_NORMAL)
	
	physical_readout.text = "{used}/{max}".format({
		"used" : used_phys,
		"max" : max_phys,
	})
	mental_readout.text  = "{used}/{max}".format({
		"used" : used_ment,
		"max" : max_ment,
	})

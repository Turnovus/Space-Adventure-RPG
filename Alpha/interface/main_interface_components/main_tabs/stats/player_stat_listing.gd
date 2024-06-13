extends Control


@onready var icon = $Icon
@onready var label = $Label
@onready var value = $Value


func set_stat(stat : Stat, agent : Agent):
	if stat.icon != null:
		icon.texture = stat.icon
	
	label.text = stat.label
	value.text = str(stat.get_current_potency(agent))
	
	tooltip_text = stat.description

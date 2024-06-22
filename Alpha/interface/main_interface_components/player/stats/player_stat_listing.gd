extends Control


@onready var icon = $Icon
@onready var label = $Label
@onready var value = $Value


func set_stat(stat : Stat, agent : Agent):
	if stat.icon != null:
		icon.texture = stat.icon
	
	label.text = stat.label
	value.text = str( snapped(stat.get_current_potency(agent), 0.01) )
	
	tooltip_text = stat.description

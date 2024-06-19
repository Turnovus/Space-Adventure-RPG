extends HBoxContainer


@onready var icon = $Icon
@onready var factor =  $Factor
@onready var offset = $Offset


func set_component(component : ConditionComponentStatEffector):
	if component.stat.icon != null:
		icon.texture = component.stat.icon
	
	if component.stat_potency_factor != 0:
		factor.text = "x" + str(component.stat_potency_factor)
	else:
		factor.hide()
	
	if component.stat_potency_offset == 0:
		offset.hide()
		return
	
	offset.text = "" if component.stat_potency_offset < 0 else "+"
	offset.text += component.stat_potency_offset

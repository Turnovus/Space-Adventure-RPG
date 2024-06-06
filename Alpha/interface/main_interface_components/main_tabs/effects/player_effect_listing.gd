extends HBoxContainer


@onready var icon = $Icon
@onready var status = $Status


func set_condition(data : ConditionDegreeData):
	status.text = data.label
	if data.icon != null:
		icon.texture = data.icon

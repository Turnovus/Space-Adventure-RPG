extends VBoxContainer


@onready var icon = $HBoxContainer/Icon
@onready var status = $HBoxContainer/Status
@onready var sub_list = $HFlowContainer

@onready var stat_listing = preload("res://interface/main_interface_components/main_tabs/effects/stat_effect_listing.tscn")


func set_condition(data : ConditionDegreeData):
	status.text = data.label
	if data.icon != null:
		icon.texture = data.icon
	
	for child in data.get_children():
		var component = child as ConditionComponentStatEffector
		if component == null:
			continue
		
		var new_listing = stat_listing.instantiate()
		sub_list.add_child(new_listing)
		new_listing.set_component(component)

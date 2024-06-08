extends HBoxContainer


@onready var option : OptionButton = $OptionButton
@onready var label = $Label


signal dirty_listing


func set_component(component : ActionComponent):
	label.text = component.label
	
	var children = component.get_children()
	for i in range(0, component.get_child_count()):
		option.add_item(children[i].label)
		if children[i] == component.selected_option:
			option.selected = i
	
	option.item_selected.connect(component._on_option_selected)
	option.item_selected.connect(_on_option_selected)
	option.item_selected.emit(option.selected)


func _on_option_selected(_index : int):
	dirty_listing.emit()

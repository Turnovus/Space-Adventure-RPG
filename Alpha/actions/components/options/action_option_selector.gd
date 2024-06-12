class_name ActionOptionSelector
extends ActionComponent


@export var label : String

var selected_option : ActionOption


func _ready():
	for child in get_children():
		if not child is ActionOption:
			push_error("ActionOptionSelector has non-ActionOption child.")
	
	selected_option = get_child(0)


func set_option(option : ActionOption):
	selected_option = option


func get_option() -> ActionOption:
	return selected_option


func _on_option_selected(index : int):
	set_option(get_child(index))


func get_sub_components() -> Array[ActionComponent]:
	var sub_components : Array[ActionComponent] = super()
	
	if selected_option == null:
		selected_option = get_child(0)
	
	for child in selected_option.get_children():
		if child is ActionComponent:
			sub_components.append(child)
			sub_components.append_array(child.get_sub_components())
	
	return sub_components

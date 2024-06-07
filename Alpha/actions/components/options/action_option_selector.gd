extends ActionComponent
class_name ActionOptionSelector


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

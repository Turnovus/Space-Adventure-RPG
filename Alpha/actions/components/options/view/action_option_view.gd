extends OptionButton


func set_component(component : ActionComponent):
	for child in component.get_children():
		add_item(child.label)
	
	item_selected.connect(component._on_option_selected)

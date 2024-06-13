extends Control


@onready var tab_container : TabContainer = $TabContainer


func _ready():
	var tabs = tab_container.get_children()
	for i in range(0, len(tabs)):
		var tab : Control = tab_container.get_child(i)
		var controller = get_tab_controller(tab)
		if controller != null:
			setup_tab(i, controller)


func get_tab_controller(node : Control) -> TabController:
	for child in node.get_children():
		if child is TabController:
			return child
	return null


func setup_tab(tab_index : int, controller : TabController):
	tab_container.set_tab_icon(tab_index, controller.tab_icon)

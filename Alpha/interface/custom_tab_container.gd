class_name CustomTabContainer
extends TabContainer


func _ready():
	var tabs = get_children()
	var tab_index = 0
	for i in range(0, len(tabs)):
		var tab : Control = get_child(i) as Control
		if tab == null:
			continue
		var controller = get_tab_controller(tab)
		if controller != null:
			setup_tab(tab_index, controller)
		tab_index += 1


func get_tab_controller(node : Control) -> TabController:
	for child in node.get_children():
		if child is TabController:
			return child
	return null


func setup_tab(tab_index : int, controller : TabController):
	set_tab_icon(tab_index, controller.tab_icon)

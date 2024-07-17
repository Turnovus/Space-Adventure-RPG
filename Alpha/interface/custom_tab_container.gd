class_name CustomTabContainer
extends TabContainer


var default_titles : Array[String] = []


func _ready():
	var tabs = get_children()
	var tab_index = 0
	for i in range(0, len(tabs)):
		var tab : Control = get_child(i) as Control
		if tab == null:
			continue
		
		default_titles.append(get_tab_title(tab_index))
		
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
	controller.tab_count_changed.connect(_on_tab_count_changed)
	update_tab(tab_index, controller)


func update_tab(tab_index : int, controller : TabController):
	if controller == null:
		return
	
	var count : int = controller.count
	var title : String = default_titles[tab_index]
	match controller.show_count:
		TabController.TabCountDisplay.NEVER:
			return
		TabController.TabCountDisplay.NOT_ZERO:
			if count == 0:
				set_tab_title(tab_index, title)
				return
	
	var format_string = "{title} ({count})"
	set_tab_title(tab_index, format_string.format({
		"title" : title,
		"count" : count,
	}))


func _on_tab_count_changed(tab : Control):
	var tab_index : int = get_tab_idx_from_control(tab)
	if tab_index < 0:
		return
	
	var controller : TabController = get_tab_controller(tab)
	update_tab(tab_index, controller)

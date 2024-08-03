extends PanelContainer


@onready var icon_action : TextureRect = $VBoxContainer/TopBar/ActionIcon
@onready var icon_physical : TextureRect = $VBoxContainer/TopBar/PhysicalIcon
@onready var icon_mental : TextureRect = $VBoxContainer/TopBar/MentalIcon

@onready var action_label : Label = $VBoxContainer/TopBar/ActionLabel
@onready var physical_count : Label = $VBoxContainer/TopBar/PhysicalCost
@onready var mental_count : Label = $VBoxContainer/TopBar/MentalCost

@onready var button : Button = $VBoxContainer/TopBar/Button

@onready var component_list : VBoxContainer = $VBoxContainer/ComponentViews

var action : Action
var is_player_action : bool


func set_action(new_action : Action, player_action : bool):
	action = new_action
	is_player_action = player_action
	
	if is_player_action:
		button.text = "X"
		button.pressed.connect(_on_action_remove)
	else:
		button.text = "Add"
		button.pressed.connect(_on_action_add)
	
	update_visuals()


func update_visuals():
	update_label_and_icon()
	update_point_display()
	rebuild_component_views()


func update_label_and_icon():
	if action.icon != null:
		icon_action.texture = action.icon
	
	action_label.text = action.label

func update_point_display():
	var player : Agent = await ReferenceSingleton.get_player()
	
	var physical_cost = action.get_physical_point_cost(player)
	if physical_cost == 0:
		icon_physical.hide()
		physical_count.hide()
	else:
		icon_physical.show()
		physical_count.show()
		physical_count.text = str(physical_cost)
	
	var mental_cost = action.get_mental_point_cost(player)
	if mental_cost == 0:
		icon_mental.hide()
		mental_count.hide()
	else:
		icon_mental.show()
		mental_count.show()
		mental_count.text = str(mental_cost)


func rebuild_component_views():
	var player : Agent = await ReferenceSingleton.get_player()
	
	for child in component_list.get_children():
		child.queue_free()
	
	var ranks : Dictionary = {}
	
	for component : ActionComponent in action.get_components():
		var view : Control = component.build_view_component()
		if view != null:
			var flow : HFlowContainer
			if not ranks.has(component.view_component_rank):
				flow = HFlowContainer.new()
				ranks[component.view_component_rank] = flow
				component_list.add_child(flow)
				flow.alignment = FlowContainer.ALIGNMENT_CENTER
			else:
				flow = ranks[component.view_component_rank]
			
			flow.add_child(view)
			view.set_component(component, player)
			if view.has_signal("dirty_listing"):
				view.connect("dirty_listing", _on_dirty_listing)


func _on_action_remove():
	var galaxy : Galaxy = await ReferenceSingleton.get_galaxy()
	galaxy.try_remove_player_action(action)


func _on_action_add():
	var galaxy : Galaxy = await ReferenceSingleton.get_galaxy()
	galaxy.try_add_player_action(action)


func _on_dirty_listing():
	var galaxy : Galaxy = await ReferenceSingleton.get_galaxy()
	galaxy.player_points_reallocated.emit()
	update_visuals()

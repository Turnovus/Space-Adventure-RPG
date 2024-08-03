extends VBoxContainer


@onready var event_list : BoxContainer = $ScrollContainer/Events
@onready var auto_cull_spinner : SpinBox = $PanelContainer/HBoxContainer/AutoCullSpinner

@onready var event_group = preload("res://interface/main_interface_components/main_tabs/events/event_group.tscn")

var current_group : EventGroup = null


func _ready():
	var galaxy : Galaxy = get_tree().root.get_child(0).get_galaxy()
	
	galaxy.event_pushed.connect(_on_event_pushed)
	galaxy.turn_post.connect(_on_turn_post)


func _on_event_pushed(type : EventType, targets : Array):
	if current_group == null:
		current_group = event_group.instantiate()
		event_list.add_child(current_group)
		event_list.move_child(current_group, 0)
	
	if _should_log_event(type, targets):
		current_group.add_event(type, targets)


func _should_log_event(type : EventType, targets : Array) -> bool:
	#TODO
	return true


func _on_turn_post(turn : int):
	if current_group != null:
		current_group.turn = turn
		current_group = null
	
	for child in event_list.get_children():
		var group = child as EventGroup
		if group == null:
			continue
		
		if group.turn + auto_cull_spinner.value >= turn:
			group.queue_free()

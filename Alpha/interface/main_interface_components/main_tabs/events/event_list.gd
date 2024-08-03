extends VBoxContainer


@onready var event_list = $ScrollContainer/Events

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
	
	#TODO: Cull old events

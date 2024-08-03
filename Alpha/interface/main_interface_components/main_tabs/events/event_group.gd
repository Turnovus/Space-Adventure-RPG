class_name EventGroup
extends VBoxContainer


var turn : int:
	set(new_turn):
		turn = new_turn
		date.text = DateUtil.get_full_date_string(turn)

var event_listing = preload("res://interface/main_interface_components/main_tabs/events/event_listing.tscn")

@onready var events = $Events
@onready var date : Label = $Date


func _ready():
	events.child_exiting_tree.connect(_on_event_exiting)


func add_event(type : EventType, targets : Array):
	var new_listing : EventListing = event_listing.instantiate()
	events.add_child(new_listing) #Add to tree first so onready vars initialize
	new_listing.set_event(type, targets)


func _on_event_exiting(_node : Node):
	if events.get_child_count() <= 1:
		queue_free()

extends PanelContainer


@onready var listing = preload("res://interface/main_interface_components/action_listing/action_listing.tscn")
@onready var list = $ScrollContainer/VBoxContainer


func _ready():
	var player : Agent = await ReferenceSingleton.get_player()
	player.actions.actions_changed.connect(_on_player_actions_changed)


func _on_player_actions_changed():
	var player = await ReferenceSingleton.get_player()
	
	for child in list.get_children():
		child.queue_free()
	
	for action in player.actions.get_actions():
		var new_listing = listing.instantiate()
		list.add_child(new_listing)
		new_listing.set_action(action, true)

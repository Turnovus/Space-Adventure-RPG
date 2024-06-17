extends PanelContainer


@onready var listing = preload("res://interface/main_interface_components/action_listing/action_listing.tscn")
@onready var list = $ScrollContainer/VBoxContainer


func _ready():
	var galaxy : Galaxy = get_tree().root.get_child(0).get_galaxy()
	galaxy.player_actions_changed.connect(_on_player_actions_changed)
	galaxy.turn_post.connect(_on_turn_post)


func _on_player_actions_changed():
	var galaxy : Galaxy = get_tree().root.get_child(0).get_galaxy()
	var player = galaxy.player
	
	for child in list.get_children():
		child.queue_free()
	
	for action in player.actions_this_turn:
		var new_listing = listing.instantiate()
		list.add_child(new_listing)
		new_listing.set_action(action, true)


func _on_turn_post(_turn : int):
	_on_player_actions_changed()

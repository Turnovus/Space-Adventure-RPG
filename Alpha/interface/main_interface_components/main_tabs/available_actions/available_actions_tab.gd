extends ScrollContainer


@onready var listing = preload("res://interface/main_interface_components/action_listing/action_listing.tscn")
@onready var list = $VBoxContainer


func _ready():
	var galaxy : Galaxy = get_tree().root.get_child(0).get_galaxy()
	galaxy.turn_post.connect(_on_turn_post)
	galaxy.player_actions_changed.connect(_on_player_actions_changed)
	_on_turn_post(galaxy.turn)


func regenerate_actions():
	var galaxy : Galaxy = get_tree().root.get_child(0).get_galaxy()
	var player = galaxy.player
	
	for child in list.get_children():
		child.queue_free()
	
	for action in player.get_available_actions():
		var excluded = false
		for chosen in player.actions.get_actions():
			if chosen.is_exclusive_with(action):
				excluded = true
		if excluded:
			continue
			
		var new_listing = listing.instantiate()
		list.add_child(new_listing)
		new_listing.set_action(action, false)


func _on_turn_post(_turn : int):
	regenerate_actions()


func _on_player_actions_changed():
	regenerate_actions()

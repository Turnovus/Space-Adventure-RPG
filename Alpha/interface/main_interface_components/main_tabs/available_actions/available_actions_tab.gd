extends ScrollContainer


@onready var listing = preload("res://interface/main_interface_components/action_listing/action_listing.tscn")
@onready var list = $VBoxContainer
@onready var tab_controller : TabController = $TabController


func _ready():
	var galaxy : Galaxy = await ReferenceSingleton.get_galaxy()
	galaxy.player.actions.actions_changed.connect(_on_player_actions_changed)
	galaxy.turn_post.connect(_on_turn_post)
	_on_player_actions_changed()


func regenerate_actions():
	var player : Agent = await ReferenceSingleton.get_player()
	var action_count : int = 0
	
	for child in list.get_children():
		child.queue_free()
	
	for action : Action in player.get_available_actions():
		var excluded = false
		for chosen in player.actions.get_actions():
			if chosen.is_exclusive_with(action):
				excluded = true
		if excluded:
			continue
			
		var new_listing = listing.instantiate()
		list.add_child(new_listing)
		new_listing.set_action(action, false)
		action_count += 1
	
	tab_controller.count = action_count


func _on_player_actions_changed():
	regenerate_actions()


func _on_turn_post(_turn : int):
	regenerate_actions()

extends ScrollContainer


@onready var listing = preload("res://interface/main_interface_components/main_tabs/status/player_status_listing.tscn")
@onready var list = $VBoxContainer


func _ready():
	var galaxy : Galaxy = get_tree().root.get_child(0).get_galaxy()
	galaxy.turn_post.connect(_on_turn_post)
	_on_turn_post(galaxy.turn)


func _on_turn_post(_turn : int):
	var galaxy : Galaxy = get_tree().root.get_child(0).get_galaxy()
	var player = galaxy.player
	
	for child in list.get_children():
		child.queue_free()
	
	for child in player.conditions.get_children():
		var condition : Condition = child as Condition
		if condition == null:
			continue
		
		var degree = condition.current_degree()
		if degree == null:
			continue
		
		var new_listing = listing.instantiate()
		list.add_child(new_listing)
		new_listing.set_condition(degree)

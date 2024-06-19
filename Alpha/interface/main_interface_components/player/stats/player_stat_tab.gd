extends ScrollContainer


@onready var listing = preload("res://interface/main_interface_components/player/stats/player_stat_listing.tscn")
@onready var list = $HFlowContainer


func _ready():
	var galaxy : Galaxy = get_tree().root.get_child(0).get_galaxy()
	galaxy.turn_post.connect(_on_turn_post)
	_on_turn_post(galaxy.turn)


func _on_turn_post(_turn : int):
	var galaxy : Galaxy = get_tree().root.get_child(0).get_galaxy()
	var player : Agent = galaxy.player
	
	for child in list.get_children():
		child.queue_free()
	
	for stat in player.stats.stats:
		var new_listing = listing.instantiate()
		list.add_child(new_listing)
		new_listing.set_stat(stat, player)

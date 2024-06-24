extends ScrollContainer


@onready var galaxy : Galaxy = get_tree().root.get_child(0).get_galaxy()
@onready var list : ActionList = $VBoxContainer


func _ready():
	galaxy.turn_post.connect(_on_turn_post)
	galaxy.player_actions_changed.connect(_on_player_actions_changed)
	
	update_list()


func update_list():
	list.update(galaxy.player.get_doable_actions())
	list.update_listing_visibility_for(galaxy.player)


func _on_turn_post(_turn : int):
	update_list()


func _on_player_actions_changed():
	update_list()

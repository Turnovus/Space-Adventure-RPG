extends PanelContainer


@onready var galaxy : Galaxy = get_tree().root.get_child(0).get_galaxy()
@onready var list : ActionList = $ScrollContainer/VBoxContainer


func _ready():
	galaxy.turn_post.connect(_on_turn_post)
	galaxy.player_actions_changed.connect(_on_player_actions_changed)
	
	list.update(galaxy.player.get_actions_doing())


func _on_turn_post(_turn : int):
	list.update(galaxy.player.get_actions_doing())


func _on_player_actions_changed():
	list.update(galaxy.player.get_actions_doing())

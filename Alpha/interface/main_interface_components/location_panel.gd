extends PanelContainer


@onready var location_name : Label = $"CenterContainer/HBoxContainer/LocationName"


func _ready():
	var galaxy : Galaxy = get_tree().root.get_child(0).get_galaxy()
	galaxy.turn_post.connect(_on_turn_post)
	_on_turn_post(galaxy.turn)


func get_player() -> Agent:
	var galaxy : Galaxy = get_tree().root.get_child(0).get_galaxy()
	return galaxy.player


func _on_turn_post(_turn):
	location_name.text = get_player().get_parent().name

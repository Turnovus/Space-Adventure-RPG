class_name ActionComponentCraftValidator
extends ActionComponent


var player : Agent


func _ready() -> void:
	player = await  ReferenceSingleton.get_player()
	player.inventory.contents_modified.connect(_on_player_inventory_changed)


func build_view_component() -> Control:
	view = Label.new()
	view.set("theme_override_colors/font_color", GameColorUtil.COLOR_BAD_READABLE)
	_on_player_inventory_changed()
	return view


func action_possible(agent : Agent) -> bool:
	return _anything_to_craft(agent)


func _anything_to_craft(agent : Agent) -> bool:
	return len(get_parent().get_unfinished_items(agent)) > 0


func _on_player_inventory_changed():
	if not _anything_to_craft(player):
		view.text = "Nothing to craft."
		view.show()
		return
	
	view.hide()

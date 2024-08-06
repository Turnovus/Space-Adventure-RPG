@icon("res://assets/textures/object/magnifying-glass.svg")
extends Node


func get_galaxy(wait_ready : bool = true) -> Galaxy:
	var root : Node = get_tree().root
	var index = root.get_child_count() - 1
	var galaxy = root.get_child(index).get_galaxy()
	
	if wait_ready and not galaxy.is_node_ready():
		await galaxy.ready
	return galaxy


func get_player(wait_ready : bool = true) -> Agent:
	var galaxy : Galaxy = await get_galaxy(wait_ready)
	return galaxy.player

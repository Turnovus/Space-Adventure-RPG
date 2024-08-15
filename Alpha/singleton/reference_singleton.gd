@icon("res://assets/textures/object/magnifying-glass.svg")
extends Node


func get_root() -> Node:
	return get_tree().root


func get_main() -> Node:
	var root : Node = get_root()
	var index = root.get_child_count() - 1
	return root.get_child(index)


func get_galaxy(wait_ready : bool = true) -> Galaxy:
	var galaxy = get_main().get_galaxy()
	if wait_ready and not galaxy.is_node_ready():
		await galaxy.ready
	return galaxy


func get_player(wait_ready : bool = true) -> Agent:
	var galaxy : Galaxy = await get_galaxy(wait_ready)
	return galaxy.player

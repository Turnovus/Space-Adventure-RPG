@icon("res://assets/textures/body/skills.svg")
class_name Inventory
extends Node


signal contents_modified


func _ready():
	child_entered_tree.connect(_on_tree_modified)
	child_exiting_tree.connect(_on_tree_modified)


func do_turn(turn : int):
	for child in get_children():
		var entity = child as Entity
		if entity == null:
			continue
		
		entity.do_turn(turn)


func get_all_contents() -> Array[Item]:
	return get_contained_items(self)


func get_contained_items(node : Node) -> Array[Item]:
	var items : Array[Item] = []
	
	for child : Node in node.get_children():
		var item : Item = child as Item
		if item != null:
			items.append(item)
		#TODO: Support for items stored in items
		# The below line will include e.g. components of unfinished items, so we need a more clear
		# definition of the difference between contents and components.
		#items.append_array(get_contained_items(child))
	
	return items


func get_best_tools() -> Dictionary:
	var best_tools : Dictionary = {} # {ToolTemplate : Item}
	
	for item : Item in get_all_contents():
		for tool : ToolTemplate in item.get_available_tools():
			if not best_tools.has(tool):
				best_tools[tool] = item
				continue
			if item.get_tool_effectiveness(tool) > best_tools[tool].get_tool_effectiveness(tool):
				best_tools[tool] = item
	
	return best_tools


func _on_tree_modified(_node : Node):
	if not is_queued_for_deletion():
		contents_modified.emit()

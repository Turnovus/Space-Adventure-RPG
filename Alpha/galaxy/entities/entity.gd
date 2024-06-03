extends Node
class_name Entity


var turn_created = 0
var location_relative : Vector2 = Vector2(0,0)


signal location_changed(this : Entity)


func _ready():
	var galaxy : Galaxy = get_tree().root.get_child(0).get_galaxy()
	turn_created = galaxy.turn


func add_child_entity(entity: Entity):
	add_child(entity)


func remove_child_entity(entity: Entity):
	remove_child(entity)


func do_turn():
	_turn_action()
	
	for child : Node in get_children():
		if child is Entity:
			child.do_turn()


func _turn_action():
	pass

extends Node
class_name Entity


var turn_created = 0


func _ready():
	var galaxy : Galaxy = get_tree().root.get_child(0).get_galaxy()
	turn_created = galaxy.turn


func do_turn():
	_turn_action()
	
	for child : Node in get_children():
		if child is Entity:
			child.do_turn()


func _turn_action():
	pass

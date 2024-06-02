extends Node
class_name Entity


func do_turn():
	_turn_action()
	
	for child : Node in get_children():
		if child is Entity:
			child.do_turn()


func _turn_action():
	pass

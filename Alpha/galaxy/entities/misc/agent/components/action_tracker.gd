class_name ActionTracker
extends Node


func get_agent() -> Agent:
	return get_parent() as Agent


func get_actions() -> Array[Action]:
	var actions : Array[Action] = []
	for child in get_children():
		if child is Action:
			actions.append(child)
	return actions


func allocated_physical_points() -> int:
	var points : int = 0
	for action in get_actions():
		points += action.get_physical_point_cost(get_agent())
	return points


func allocated_mental_points() -> int:
	var points : int = 0
	for action in get_actions():
		points += action.get_mental_point_cost(get_agent())
	return points


func do_turn():
	for action in get_actions():
		action.action_turn(get_agent())


func validate_actions():
	for action in get_actions():
		if not action.sustain_action(get_agent()):
			action.queue_free()


func count_actions() -> int:
	return len(get_actions())

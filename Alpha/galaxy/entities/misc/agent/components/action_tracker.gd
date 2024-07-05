class_name ActionTracker
extends Node


signal action_added
signal action_removed
signal actions_changed


func get_agent() -> Agent:
	return get_parent() as Agent


func get_actions() -> Array[Action]:
	var actions : Array[Action] = []
	for child in get_children():
		if child is Action:
			actions.append(child)
	return actions


func add_action(action : Action):
	if get_children().has(action):
		return
	if action.get_parent() != null:
		action.reparent(self)
	else:
		add_child(action)
	action_added.emit()
	actions_changed.emit()


func remove_action(action : Action):
	if not get_children().has(action):
		return
	action.queue_free()
	remove_child(action)
	action_removed.emit()
	actions_changed.emit()


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
	print("validate_actions")
	for action in get_actions():
		if not action.sustain_action(get_agent()):
			remove_action(action)


func count_actions() -> int:
	return len(get_actions())

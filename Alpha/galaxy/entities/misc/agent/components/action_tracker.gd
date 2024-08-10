@icon("res://assets/textures/body/skills.svg")
class_name ActionTracker
extends Node


signal action_added
signal action_removed
signal actions_changed
## Emitted when activity points are spent, or when they are refunded at the end of a turn.
signal activities_changed


## How many activity points each action point is worth.
@export var activity_point_value : int = 1
## Out of the agent's available action points, how many can be converted into activity points.
@export var max_activity_factor : float = 1

var physical_activities_this_turn : Dictionary
var mental_activities_this_turn : Dictionary


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
	
	points += ceili(float(get_num_physical_activities()) / activity_point_value)
	return points


func allocated_mental_points() -> int:
	var points : int = 0
	for action in get_actions():
		points += action.get_mental_point_cost(get_agent())
	
	points += ceili(float(get_num_mental_activities()) / activity_point_value)
	return points


func do_turn():
	for action in get_actions():
		action.action_turn(get_agent())
	clear_activities()


func clear_activities():
	physical_activities_this_turn = {}
	mental_activities_this_turn = {}
	activities_changed.emit()


func validate_actions():
	for action in get_actions():
		if not action.sustain_action(get_agent()):
			remove_action(action)


func count_actions() -> int:
	return len(get_actions())


func get_num_physical_activities() -> int:
	var count : int = 0
	for key : String in physical_activities_this_turn.keys():
		count += physical_activities_this_turn[key]
	return count


func get_num_mental_activities() -> int:
	var count : int = 0
	for key : String in mental_activities_this_turn.keys():
		count += mental_activities_this_turn[key]
	return count


func get_max_physical_activities() -> int:
	var action_points = get_agent().max_physical_points()
	return floori(action_points * max_activity_factor) * activity_point_value


func get_max_mental_activities() -> int:
	var action_points = get_agent().max_mental_points()
	return floori(action_points * max_activity_factor) * activity_point_value


func spend_physical_activity_points(category : String, points : int):
	if points <= 0:
		return
	
	if not physical_activities_this_turn.has(category):
		physical_activities_this_turn[category] = 0
	
	var total_points = physical_activities_this_turn[category]
	total_points = min(get_max_physical_activities(), total_points + points)
	physical_activities_this_turn[category] = total_points
	activities_changed.emit()


func spend_mental_activity_points(category : String, points : int):
	if points <= 0:
		return
	
	if not mental_activities_this_turn.has(category):
		mental_activities_this_turn[category] = 0
	
	var total_points = mental_activities_this_turn[category]
	total_points = min(get_max_mental_activities(), total_points + points)
	mental_activities_this_turn[category] = total_points
	activities_changed.emit()

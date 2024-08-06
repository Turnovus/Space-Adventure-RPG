class_name ActionIssuer
extends Node


@export var action_scene : PackedScene


func issue_action(_agent : Agent) -> Action:
	for child in get_children():
		if child is Action:
			return child
	var action = action_scene.instantiate() as Action
	action.issuer = get_parent()
	add_child(action)
	return action

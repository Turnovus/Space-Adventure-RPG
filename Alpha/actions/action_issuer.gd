extends Node
class_name ActionIssuer


@export var action_scene : PackedScene


func issue_action(agent : Agent) -> Action:
	var action = action_scene.instantiate() as Action
	return action

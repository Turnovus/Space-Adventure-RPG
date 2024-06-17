extends Node
class_name ActionIssuer


@export var action_scene : PackedScene


func issue_action(_agent : Agent) -> Action:
	var action = action_scene.instantiate() as Action
	action.issuer = get_parent()
	return action

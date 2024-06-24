class_name ActionIssuer
extends Node


@export var actions : Array[Action] = []


func get_actions_available_to(agent : Agent) -> Array[Action]:
	return actions

class_name ActionDoer
extends Node


var action : Action
var issuer : Entity


func _init(new_action : Action, new_issuer : Entity):
	action = new_action
	issuer = new_issuer


func get_agent() -> Agent:
	if get_parent() is ActionTracker:
		return get_node("../../") as Agent
	return null


func get_parameters(preview_agent : Agent = null) -> Dictionary:
	return action.get_parameters(self, preview_agent)

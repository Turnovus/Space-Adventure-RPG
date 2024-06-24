class_name ActionIssuer
extends Node


@export var action : Action


func get_doer() -> ActionDoer:
	var doer : ActionDoer
	for child in get_children():
		doer = child as ActionDoer
		if doer != null:
			return doer
	
	doer = action.create_doer(get_parent())
	add_child(doer)
	return doer

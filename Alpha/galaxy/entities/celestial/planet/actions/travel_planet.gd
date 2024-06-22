extends Action


@export var direction_option : ActionOptionSelector


func sustain_action(agent : Agent) -> bool:
	return agent.get_parent() == issuer


func _do_action(agent : Agent):
	var movement = get_potency(agent)
	var direction = direction_option.get_option().value.normalized()
	
	agent.move_relative(direction * movement)

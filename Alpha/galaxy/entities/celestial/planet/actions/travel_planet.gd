extends Action


@export var direction_option : ActionOptionSelector


func sustain_action(agent : Agent) -> bool:
	return agent.get_parent() == issuer


func _do_action(agent : Agent, potency : float):
	var direction : Vector2 = direction_option.get_option().value.normalized()
	
	agent.move_relative(direction * potency)

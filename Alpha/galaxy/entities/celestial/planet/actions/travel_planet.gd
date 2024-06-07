extends Action


@export var direction_option : ActionOptionSelector


func action_turn(agent : Agent):
	var movement = get_potency()
	var direction = direction_option.get_option().value.normalized()
	
	agent.move_relative(direction * movement)

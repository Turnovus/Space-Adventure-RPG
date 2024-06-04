extends Action
class_name Action_TravelDirectional


@export var movement : Vector2


func resolve_action(agent : Agent):
	agent.move_relative(movement)

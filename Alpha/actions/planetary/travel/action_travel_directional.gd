extends Action
class_name Action_TravelDirectional


@export var movement : Vector2


func action_resolve(agent : Agent):
	agent.move_relative(movement)

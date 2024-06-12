class_name ActionComponentPotencyFactor
extends ActionComponent


@export var factor : float = 1


func affect_potency(initial_potency : float, _agent : Agent) -> float:
	return initial_potency * factor

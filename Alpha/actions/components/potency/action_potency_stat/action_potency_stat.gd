class_name ActionComponentPotencyStat
extends ActionComponent


@export var stat : Stat
@export var factor : float = 1


func affect_potency(initial_potency : float, agent : Agent) -> float:
	var stat_potency = 1
	stat_potency = stat.get_current_potency(agent)
	
	return initial_potency * (factor * stat_potency)

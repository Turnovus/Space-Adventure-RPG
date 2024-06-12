class_name ActionComponentPotencyStat
extends ActionComponent


@export var stat_name : String
@export var factor : float = 1


func affect_potency(initial_potency : float, agent : Agent) -> float:
	var stat : Stat = agent.stats.get_node(stat_name) as Stat
	var stat_potency = 1
	if stat != null:
		stat_potency = stat.get_current_potency()
	else:
		push_warning("Stat not found: " + stat_name)
	
	return initial_potency * (factor * stat_potency)

class_name ActionComponentPointFraction
extends ActionComponent


@export var physical_point_percent : float = 0
@export var mental_point_percent : float = 0
@export_subgroup("potency")
@export var physical_allocation_affects_potency : bool = false
@export var base_physical_points : float = 1
@export var mental_allocation_affects_potency : bool = false
@export var base_mental_points : float = 1


func modify_parameters(parameters : Dictionary, doer : ActionDoer, preview_agent : Agent = null):
	var agent : Agent = doer.get_agent()
	if agent == null:
		if preview_agent == null:
			return
		agent = preview_agent
	
	var physical: int = int(agent.max_physical_points() * physical_point_percent)
	var mental : int = int(agent.max_mental_points() * mental_point_percent)
	parameters[Action.PARAMETER_POINT_COST_PHYSICAL] += physical
	parameters[Action.PARAMETER_POINT_COST_MENTAL] += mental

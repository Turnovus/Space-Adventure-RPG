class_name Stat
extends Resource


@export var icon : Texture2D
@export var label : String
@export_multiline var description : String
@export var base_value : float = 1
@export_subgroup("effectors")
@export var skills : Array[StatEffectorSkill] = []


func get_base_potency() -> float:
	return base_value


func get_current_potency(agent : Agent) -> float:
	var potency = get_base_potency()
	var factor = 1
	var offset = 0
	
	for skill in skills:
		factor *= skill.get_factor(agent)
	
	for condition : Condition in agent.conditions.get_children():
		var degree = condition.current_degree()
		if degree == null:
			continue
			
		for child in degree.get_children():
			var component : ConditionComponentStatEffector = child as ConditionComponentStatEffector
			
			if component == null or component.stat != self:
				continue
			factor *= component.stat_potency_factor
			offset += component.stat_potency_offset
	
	return (potency + offset) * factor

extends Node
class_name Stat


@export var icon : Texture2D
@export var label : String
@export_multiline var description : String
@export var base_value : float = 1


func get_base_potency() -> float:
	return base_value


func get_current_potency() -> float:
	var agent : Agent = get_parent().get_parent()
	var potency = get_base_potency()
	var factor = 1
	var offset = 0
	
	for condition : Condition in agent.conditions.get_children():
		for child in condition.get_children():
			var component : ConditionComponentStatEffector = child as ConditionComponentStatEffector
			if component == null or component.stat != self:
				continue
			factor *= component.stat_potency_factor
			offset += component.stat_potency_offset
	
	return (potency + offset) * factor

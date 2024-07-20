class_name ActionComponentPotencySkill
extends ActionComponent


@export var skill : Skill
@export var base_value : float = 1
@export var factor : float = 1
@export var use_exact_level : bool = true


func affect_potency(initial_potency : float, agent : Agent) -> float:
	var potency = agent.skills.get_exact_level(skill) if use_exact_level else agent.skills.get_level(skill)
	potency *= factor
	potency += base_value
	return initial_potency * potency

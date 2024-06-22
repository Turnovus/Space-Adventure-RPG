class_name StatEffectorSkill
extends Resource


@export var skill : Skill
@export var base_factor : float = 1
@export var factor_offset_per_level : float = 0
@export var use_exact_level : bool


func get_factor(agent : Agent) -> float:
	var skills = agent.skills
	var level = skills.get_exact_level(skill) if use_exact_level else skills.get_level(skill)
	return base_factor + (level * factor_offset_per_level)

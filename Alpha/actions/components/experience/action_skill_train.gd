class_name ActionComponentSkillTrain
extends ActionComponent


@export var skill : Skill
@export var expeience : float = 1


func turn_action(agent : Agent, _potency : float):
	agent.skills.add_experience(skill, expeience)

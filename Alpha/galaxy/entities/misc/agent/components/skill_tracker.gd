class_name SkillTracker
extends  Node


signal skill_altered(skill : Skill, level_before : float, level_after : float)

const BASE_EXPERIENCE_NEEDED = 100
const EXPERIENCE_FACTOR_PER_LEVEL = 1.1

@export var skills : Array[Skill] = []
@export var skill_increase_event : EventType

var skill_progress : Dictionary = {}


func _ready():
	for skill in skills:
		skill_progress[skill] = SkillProgress.new()


func get_level(skill : Skill) -> int:
	return skill_progress[skill].level


func get_experience(skill : Skill) -> float:
	return skill_progress[skill].experience


func get_exact_level(skill : Skill) -> float:
	return skill_progress[skill].get_exact_level()


func get_experience_needed(skill : Skill) -> int:
	return skill_progress[skill].get_experience_needed()


func add_experience(skill : Skill, experience : float):
	var level_before = get_exact_level(skill)
	skill_progress[skill].add_experience(experience)
	var level_after = get_exact_level(skill)
	
	skill_altered.emit(skill, level_before, level_after)
	
	if int(level_before) < int(level_after):
		var galaxy : Galaxy = get_tree().root.get_child(0).get_galaxy()
		galaxy.push_event(skill_increase_event, [get_parent(), skill, level_after])


class SkillProgress:
	var level : int = 0
	var experience : float = 0
	
	
	func get_exact_level() -> float:
		return level + (experience / get_experience_needed())
	
	
	func get_experience_needed() -> int:
		return int(BASE_EXPERIENCE_NEEDED * pow(EXPERIENCE_FACTOR_PER_LEVEL, level))
	
	
	func add_experience(amount : float):
		experience += amount
		while experience > get_experience_needed():
			experience -= get_experience_needed()
			level += 1

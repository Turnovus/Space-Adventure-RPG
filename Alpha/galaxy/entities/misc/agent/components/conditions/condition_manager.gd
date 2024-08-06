@icon("res://assets/textures/body/skills.svg")
class_name ConditionManager
extends Node


func _ready():
	var parent = get_parent()
	update(parent)


func update(agent : Agent):
	for child in get_children():
		if not child is Condition:
			continue
		child.update(agent)

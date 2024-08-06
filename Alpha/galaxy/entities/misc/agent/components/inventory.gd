@icon("res://assets/textures/body/skills.svg")
class_name Inventory
extends Node


func do_turn(turn : int):
	for child in get_children():
		var entity = child as Entity
		if entity == null:
			continue
		
		entity.do_turn(turn)

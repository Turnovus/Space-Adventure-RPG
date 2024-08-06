@icon("res://assets/textures/place/forest.svg")
class_name Biome
extends Resource


@export var label : String
@export var map_color : Color
@export var allow_spawn : bool = true
@export_subgroup("resources")
@export var forage_groups : Array[BiomeForage] = []


func can_forage(forage : ForageGroup) -> bool:
	for group : BiomeForage in forage_groups:
		if group.forage_group == forage:
			return true
	return false

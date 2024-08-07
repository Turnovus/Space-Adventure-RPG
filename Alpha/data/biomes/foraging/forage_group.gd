@icon("res://assets/textures/object/container/basket.svg")
class_name ForageGroup
extends Resource


@export var label : String
@export_subgroup("Richness")
@export var min_natural_richness : float = 0
@export var max_natural_richness : float = 1
@export_subgroup("Replenish")
@export var replenish_turns : int = 1
@export var winter_replenish_factor : float = 1
@export_subgroup("Depletion")
@export var depletion_per_forage : float
@export_subgroup("Content")
@export var items : Array[ItemTemplate] = []


func get_forage() -> Node:
	var template : ItemTemplate = items.pick_random()
	var item : Item = Item.new()
	item.template = template
	return item

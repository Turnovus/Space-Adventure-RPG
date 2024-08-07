@icon("res://assets/textures/ui/open-folder.svg")
class_name CraftingGroup
extends Resource


@export var label : String
@export var child_groups : Array[CraftingGroup] = []
@export var recipes : Array[CraftingRecipe] = []

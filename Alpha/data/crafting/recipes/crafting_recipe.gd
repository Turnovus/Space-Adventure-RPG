@icon("res://assets/textures/object/banging-gavel.svg")
class_name CraftingRecipe
extends Resource


@export var label : String
@export_multiline var description : String
@export var icon : Texture2D
@export var ingredients : Array[RecipeIngredient]
@export var tools : Array[RecipeTool]

@icon("res://assets/textures/object/banging-gavel.svg")
class_name CraftingRecipe
extends Resource


@export var label : String
@export_multiline var description : String
@export var icon : Texture2D
@export var ingredients : Array[RecipeIngredient]
@export var tools : Array[RecipeTool]
@export var physical_labor : float = 0
@export var mental_labor : float = 0
@export var physical_activity_cost : int = 0
@export var mental_activity_cost : int = 0
@export var units_label : String = "components"

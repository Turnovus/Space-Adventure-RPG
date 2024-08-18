class_name UnfinishedItem
extends Item


var recipe : CraftingRecipe:
	set(new_recipe):
		recipe = new_recipe
		_notify_recipe_changed()

var labor_completed_physical : float
var labor_completed_mental : float
var labor_completed_tools : Dictionary

var parts : Array[PartGroup] = []
var active_group_index = -1


func push_part_group(ingredient : RecipeIngredient):
	active_group_index += 1
	var group = PartGroup.new()
	group.ingredient = ingredient
	parts.append(group)


func push_part(item : Item):
	parts[active_group_index].items.append(item)
	add_child_entity(item)


func _notify_recipe_changed():
	label = "unfinished " + recipe.label #TODO: Use product label.
	icon = recipe.icon
	description = recipe.description


class PartGroup:
	var ingredient : RecipeIngredient
	var items : Array[Item] = []

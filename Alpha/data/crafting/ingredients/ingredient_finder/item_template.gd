class_name RecipeIngredientFinderTemplate
extends RecipeIngredientFinder


@export var template : ItemTemplate


func matches_filter(target : Item) -> bool:
	var item : Item = target as Item
	return item != null and item.template == template


func alter_recipe_text(_text : String) -> String:
	return template.label

class_name RecipeIngredientFinder
extends Resource


func matches_filter(_target : Item) -> bool:
	return false


func alter_recipe_text(text : String) -> String:
	return text


func is_satisfactory(ingredients : Array[Item]) -> bool:
	for ingredient : Item in ingredients:
		if not matches_filter(ingredient):
			return false
	return true

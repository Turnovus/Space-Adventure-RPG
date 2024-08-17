class_name RecipeIngredientCounter
extends Resource


enum RecipeSatisfaction {
	DEFICIENT,
	SATISFACTORY,
	EXCESS,
}


func is_satisfactory(ingredients : Array[Item]) -> RecipeSatisfaction:
	return RecipeSatisfaction.SATISFACTORY


func alter_recipe_text(text : String) -> String:
	return text


func get_completion_text(ingredients : Array[Item]) -> String:
	return ""

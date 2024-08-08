class_name RecipeIngredientCounterQuantity
extends RecipeIngredientCounter


@export var count : int = 1


func is_satisfactory(ingredients : Array[Entity]) -> bool:
	return false


func alter_recipe_text(text : String) -> String:
	return "{count} x {text}".format({
		"count" : count,
		"text" : text,
	})

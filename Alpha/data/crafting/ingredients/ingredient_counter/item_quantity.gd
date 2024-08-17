class_name RecipeIngredientCounterQuantity
extends RecipeIngredientCounter


@export var count : int = 1
@export var allow_excess : bool = false


func is_satisfactory(ingredients : Array[Item]) -> RecipeSatisfaction:
	if len(ingredients) < count:
		return RecipeSatisfaction.DEFICIENT
	if len(ingredients) > count and not allow_excess:
		return RecipeSatisfaction.EXCESS
	return RecipeSatisfaction.SATISFACTORY 


func alter_recipe_text(text : String) -> String:
	return "{count} x {text}".format({
		"count" : count,
		"text" : text,
	})


func get_completion_text(items : Array[Item]) -> String:
	return "({len}/{count})".format({
		"len" : len(items),
		"count" : count,
	})

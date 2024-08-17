class_name RecipeIngredient
extends Resource


## Used to represent what happens to an ingredient once the recipe is complete.
enum UsageMode {
	## The ingredient is returned to the crafter's inventory.
	NONE,
	## The ingredient is consumed and destroyed.
	CONSUMED,
	## The ingredient becomes a component of the product.
	ASSEMBLED,
	## The ingredient is returned to the crafter's inventory, but is modified.
	MODIFIED,
}


const USAGE_TEXT = [
	"consumed",
	"assembled",
	"modified",
]

@export var icon : Texture2D
@export var usage : UsageMode = UsageMode.NONE
@export var finder : RecipeIngredientFinder
@export var counter : RecipeIngredientCounter


func get_recipe_text() -> String:
	var text : String = "item"
	text = finder.alter_recipe_text(text)
	text = counter.alter_recipe_text(text)
	
	if usage != 0:
		text += " ({usage})".format({"usage" : USAGE_TEXT[usage - 1]})
	
	return text


func is_satisfactory(ingredients : Array[Item]) -> bool:
	if not finder.is_satisfactory(ingredients):
		return false
	
	if counter.is_satisfactory(ingredients) != RecipeIngredientCounter.RecipeSatisfaction.SATISFACTORY:
		return false
	
	return true

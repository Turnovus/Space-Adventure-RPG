class_name RecipeIngredientFinderUnfinishedTool
extends RecipeIngredientFinder


func matches_filter(target : Item) -> bool:
	return not target.is_assembled_tool and len(target.get_available_tools()) > 0


func alter_recipe_text(_text : String) -> String:
	return "tool head"

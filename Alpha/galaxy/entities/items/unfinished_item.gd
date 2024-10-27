class_name UnfinishedItem
extends Item


var recipe : CraftingRecipe:
	set(new_recipe):
		recipe = new_recipe
		_notify_recipe_changed()

var labor_completed_physical : float
var labor_completed_mental : float

var parts : Array[PartGroup] = []
var active_group_index = -1


func fill_description(target : RichTextLabel, size_main : int, size_extra : int, size_icon : int) -> void:
	start_description(target, size_main, size_extra)
	fill_labor_description(target, size_icon)
	fill_tool_description(target, size_icon)
	fill_part_description(target, size_icon)


func fill_labor_description(target : RichTextLabel, size_icon : int) -> void:
	target.append_text("\n\nWork Required:")
	target.push_list(1, RichTextLabel.LIST_DOTS, true)
	
	fill_physical_labor_description(target, size_icon)
	fill_mental_labor_description(target, size_icon)
	
	target.pop()


func fill_physical_labor_description(target : RichTextLabel, size_icon : int) -> void:
	if recipe.physical_labor <= 0:
		return
	
	target.add_image(AssetSingleton.icon_physical, size_icon, size_icon)
	target.add_text("Physical Labor: ")
	target.add_text(str(labor_completed_physical))
	target.add_text("/")
	target.add_text(str(recipe.physical_labor))
	target.add_text("\n")


func fill_mental_labor_description(target : RichTextLabel, size_icon : int) -> void:
	if recipe.mental_labor <= 0:
		return
	
	target.add_image(AssetSingleton.icon_mental, size_icon, size_icon)
	target.add_text("Mental Labor: ")
	target.add_text(str(labor_completed_mental))
	target.add_text("/")
	target.add_text(str(recipe.mental_labor))
	target.add_text("\n")


func push_part_group(ingredient : RecipeIngredient):
	active_group_index += 1
	var group = PartGroup.new()
	group.ingredient = ingredient
	parts.append(group)


func push_part(item : Item):
	parts[active_group_index].items.append(item)
	add_child_entity(item)


func update_crafting_progress(agent : Agent) -> void:
	if labor_completed_physical < recipe.physical_labor or labor_completed_mental < recipe.mental_labor:
		return
	
	var finished_item : Item = Item.new()
	
	for part : PartGroup in parts:
		match part.ingredient.usage:
			RecipeIngredient.UsageMode.NONE, RecipeIngredient.UsageMode.MODIFIED:
				for item : Item in part.items:
					item.reparent(get_parent())
			RecipeIngredient.UsageMode.CONSUMED:
				for item :  Item in part.items:
					item.queue_free()
			RecipeIngredient.UsageMode.ASSEMBLED:
				for item : Item in part.items:
					item.reparent(finished_item)
	
	finished_item.template = recipe.product
	get_parent().add_child(finished_item)
	
	if recipe.event_on_finish != null:
		var galaxy : Galaxy = await ReferenceSingleton.get_galaxy()
		galaxy.push_event(recipe.event_on_finish, [agent, finished_item])
	
	queue_free()


func _notify_recipe_changed():
	label = "unfinished " + recipe.label #TODO: Use product label.
	icon = recipe.icon
	description = recipe.description


class PartGroup:
	var ingredient : RecipeIngredient
	var items : Array[Item] = []

extends HBoxContainer


const TEXT_ICON_SIZE = 20

const TEXT_SIZE_MAIN = 35
const TEXT_SIZE_EXTRA = 15

@export var icon_physical : Texture2D
@export var icon_mental : Texture2D

var groups : Dictionary
var selected_group : CraftingGroup
var selected_recipe : CraftingRecipe

@onready var group_tree = $GroupTree
@onready var recipes = $RecipeList
@onready var readout = $RecipeInfo/Description
@onready var recipe_icon = $RecipeInfo/Header/RecipeIcon
@onready var recipe_label = $RecipeInfo/Header/RecipeLabel


func _ready():
	group_tree.item_selected.connect(_on_group_selected)
	recipes.item_selected.connect(_on_recipe_selected)
	
	var player : Agent = await ReferenceSingleton.get_player()
	_generate_groups(player)


func _generate_groups(agent : Agent):
	group_tree.clear()
	groups = {}
	_add_to_group_tree(agent.crafting_root)


func _add_to_group_tree(group : CraftingGroup, parent : TreeItem = null):
	var new_item : TreeItem = group_tree.create_item(parent)
	var item_text : String = group.label.capitalize()
	if len(group.recipes) > 0:
		new_item.set_custom_color(0, GameColorUtil.COLOR_IMPORTANCE_HIGH)
		item_text = "{label} ({count})".format({
			"label" : item_text,
			"count" : len(group.recipes),
		})
	
	new_item.set_text(0, item_text)
	groups[new_item] = group
	
	for child in group.child_groups:
		_add_to_group_tree(child, new_item)


func _generate_recipes(group : CraftingGroup):
	recipes.clear()
	for recipe : CraftingRecipe in group.recipes:
		recipes.add_item(recipe.label, recipe.icon)


func _display_recipe(recipe : CraftingRecipe):
	_update_description(recipe)
	recipe_icon.texture = recipe.icon
	recipe_label.text = recipe.label.capitalize()


func _update_description(recipe : CraftingRecipe):
	readout.push_font_size(TEXT_SIZE_MAIN)
	readout.text = recipe.description + "\n"
	readout.push_font_size(TEXT_SIZE_EXTRA)
	
	if len(recipe.ingredients) > 0:
		readout.append_text("\nIngredients:")
		readout.push_list(1, RichTextLabel.LIST_DOTS, true)
		for ingredient : RecipeIngredient in recipe.ingredients:
			#TODO: Ingredient icons
			readout.append_text(ingredient.get_recipe_text())
			readout.append_text("\n")
		readout.pop()
	
	if len(recipe.tools) > 0:
		readout.append_text("\nTools needed:")
		readout.push_list(1, RichTextLabel.LIST_DOTS, true)
		for tool : RecipeTool in recipe.tools:
			readout.add_image(tool.tool.icon, TEXT_ICON_SIZE, TEXT_ICON_SIZE)
			if tool.work_required > 0:
				readout.append_text("%s x " % str(tool.work_required))
			readout.append_text(tool.tool.label)
			if tool.min_effectiveness > 0:
				readout.append_text(" (min. %s)" % str(tool.min_effectiveness))
			readout.append_text("\n")
		readout.pop()
	
	if recipe.physical_labor > 0 or recipe.mental_labor > 0:
		readout.append_text("\nWork required:")
		readout.push_list(1, RichTextLabel.LIST_DOTS, true)
		if recipe.physical_labor > 0:
			readout.add_image(icon_physical, TEXT_ICON_SIZE, TEXT_ICON_SIZE)
			readout.append_text("Physical: ")
			readout.append_text(str(recipe.physical_labor))
			readout.append_text("\n")
		if recipe.mental_labor > 0:
			readout.add_image(icon_mental, TEXT_ICON_SIZE, TEXT_ICON_SIZE)
			readout.append_text("Mental: ")
			readout.append_text(str(recipe.mental_labor))
			readout.append_text("\n")


func _on_group_selected():
	selected_group = groups[group_tree.get_selected()]
	_generate_recipes(selected_group)


func _on_recipe_selected(index : int):
	selected_recipe = selected_group.recipes[index]
	_display_recipe(selected_recipe)

extends HBoxContainer


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
	readout.text = recipe.description
	recipe_icon.texture = recipe.icon
	recipe_label.text = recipe.label.capitalize()


func _on_group_selected():
	selected_group = groups[group_tree.get_selected()]
	_generate_recipes(selected_group)


func _on_recipe_selected(index : int):
	selected_recipe = selected_group.recipes[index]
	_display_recipe(selected_recipe)

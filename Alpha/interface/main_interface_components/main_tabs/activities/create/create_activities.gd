extends HBoxContainer


const TEXT_ICON_SIZE = 20

const TEXT_SIZE_MAIN = 35
const TEXT_SIZE_EXTRA = 15

@export var icon_physical : Texture2D
@export var icon_mental : Texture2D
@export_category("text")
@export_subgroup("create_button")
@export_multiline var create_disabled_no_selection : String
@export_multiline var create_disabled_insufficient_activities : String

var groups : Dictionary
var selected_group : CraftingGroup
var selected_recipe : CraftingRecipe

var recipe_default_icon : Texture2D
var recipe_default_text : String
var recipe_default_description : String

@onready var group_tree : Tree = $GroupTree
@onready var recipes : ItemList = $RecipeList
@onready var readout : RichTextLabel = $RecipeInfo/Description
@onready var recipe_icon : TextureRect = $RecipeInfo/Header/RecipeIcon
@onready var recipe_label : Label = $RecipeInfo/Header/RecipeLabel
@onready var create_button : Button = $RecipeInfo/CreateButton


func _ready():
	group_tree.item_selected.connect(_on_group_selected)
	recipes.item_selected.connect(_on_recipe_selected)
	create_button.pressed.connect(_on_create_pressed)
	
	var player : Agent = await ReferenceSingleton.get_player()
	_generate_groups(player)
	_validate_create_button()
	
	recipe_default_icon = recipe_icon.texture
	recipe_default_text = recipe_label.text
	recipe_default_description = readout.text


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
		recipes.add_item(recipe.label.capitalize(), recipe.icon)


func _display_recipe(recipe : CraftingRecipe):
	_update_description(recipe)
	recipe_icon.texture = recipe.icon
	recipe_label.text = recipe.label.capitalize()


func _update_description(recipe : CraftingRecipe):
	readout.push_font_size(TEXT_SIZE_MAIN)
	readout.text = recipe.description + "\n"
	readout.push_font_size(TEXT_SIZE_EXTRA)
	
	_list_recipe_activities(recipe)
	_list_recipe_ingredients(recipe)
	_list_recipe_tools(recipe)
	_list_recipe_labor(recipe)


func _list_recipe_activities(recipe : CraftingRecipe):
	if recipe.physical_activity_cost <= 0 and recipe.mental_activity_cost <= 0:
		return
	
	readout.append_text("\nInitial activity cost:")
	readout.push_list(1, RichTextLabel.LIST_DOTS, true)
	if recipe.physical_activity_cost > 0:
		readout.add_image(icon_physical, TEXT_ICON_SIZE, TEXT_ICON_SIZE)
		readout.append_text("Physical: ")
		readout.append_text(str(recipe.physical_activity_cost))
		readout.append_text("\n")
	if recipe.mental_activity_cost > 0:
		readout.add_image(icon_mental, TEXT_ICON_SIZE, TEXT_ICON_SIZE)
		readout.append_text("Mental: ")
		readout.append_text(str(recipe.mental_activity_cost))
		readout.append_text("\n")
	readout.pop()


func _list_recipe_ingredients(recipe : CraftingRecipe):
	if len(recipe.ingredients) <= 0:
		return
	
	readout.append_text("\nIngredients:")
	readout.push_list(1, RichTextLabel.LIST_DOTS, true)
	for ingredient : RecipeIngredient in recipe.ingredients:
		#TODO: Ingredient icons
		readout.append_text(ingredient.get_recipe_text())
		readout.append_text("\n")
	readout.pop()


func _list_recipe_tools(recipe : CraftingRecipe):
	if len(recipe.tools) <= 0:
		return
	
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


func _list_recipe_labor(recipe : CraftingRecipe):
	if recipe.physical_labor <= 0 and recipe.mental_labor <= 0:
		return
	
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
	readout.pop()


func _validate_create_button():
	if selected_recipe == null:
		create_button.tooltip_text = create_disabled_no_selection
		create_button.disabled = true
		return
	
	var player : Agent = await ReferenceSingleton.get_player()
	
	var actions : ActionTracker = player.actions
	var physical_activities = actions.get_num_physical_activities()
	physical_activities += selected_recipe.physical_activity_cost
	var mental_activities = actions.get_num_mental_activities()
	mental_activities += selected_recipe.mental_activity_cost
	
	var can_afford = physical_activities <= actions.get_max_physical_activities() 
	can_afford = can_afford and mental_activities <= actions.get_max_mental_activities()
	
	if not can_afford:
		create_button.tooltip_text = create_disabled_insufficient_activities
		create_button.disabled = true
		return
	
	create_button.tooltip_text = ""
	create_button.disabled = false


func _deselect_recipe():
	selected_recipe = null
	recipe_icon.texture = recipe_default_icon
	recipe_label.text = recipe_default_text
	readout.text = recipe_default_description


func _on_group_selected():
	selected_group = groups[group_tree.get_selected()]
	_generate_recipes(selected_group)
	_deselect_recipe()


func _on_recipe_selected(index : int):
	selected_recipe = selected_group.recipes[index]
	_display_recipe(selected_recipe)
	_validate_create_button()


func _on_create_pressed():
	#HACK: This method is supposed to open an ingredient selection dialogue, which itself spawns
	#the unfinished item and expends activity points. This is just a stand in so we can test the
	#activity point system.
	var player : Agent = await ReferenceSingleton.get_player()
	var actions : ActionTracker = player.actions
	actions.spend_physical_activity_points("crafting", selected_recipe.physical_activity_cost)
	actions.spend_mental_activity_points("crafting", selected_recipe.mental_activity_cost)
	_validate_create_button()

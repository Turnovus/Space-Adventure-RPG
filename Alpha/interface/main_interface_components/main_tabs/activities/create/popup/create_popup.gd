extends PanelContainer


const DESCRIPTION_ICON_SIZE : int = 16
const DESCRIPTION_FONT_SIZE_MAIN : int = 18
const DESCRIPTION_FONT_SIZE_EXTRA : int = 15

@export_subgroup("components")
@export var header_label : Label
@export var requirement_list : ItemList
@export var inventory_list : Container
@export var item_description : RichTextLabel
@export var cancel_button : Button
@export var craft_button : Button
@export_subgroup("strings")
@export_multiline var default_item_text : String

var agent : Agent
var recipe : CraftingRecipe

var available_items : Array[Array]
var selected_items : Array[Array]
var all_selections : Array[Item]
var active_index : int = 0


func _ready():
	requirement_list.item_selected.connect(_on_requirement_selected)
	craft_button.pressed.connect(_on_craft_pressed)
	cancel_button.pressed.connect(_on_cancel_pressed)
	
	cancel_button.grab_focus()
	
	_setup_header()
	_find_items()
	_build_requirements()
	_clear_item_description()


func _clear_item_description() -> void:
	item_description.clear()
	item_description.push_font_size(DESCRIPTION_FONT_SIZE_MAIN)
	item_description.append_text(default_item_text)


func _finalize_craft():
	var actions : ActionTracker = agent.actions
	actions.spend_physical_activity_points("crafting", recipe.physical_activity_cost)
	actions.spend_mental_activity_points("crafting", recipe.mental_activity_cost)
	_spawn_unfinished_item()


func _spawn_unfinished_item():
	var item : UnfinishedItem = UnfinishedItem.new()
	item.recipe = recipe
	
	for i in range(0, len(recipe.ingredients)):
		item.push_part_group(recipe.ingredients[i])
		for part : Item in selected_items[i]:
			item.push_part(part)
	
	agent.inventory.add_child(item)


func _setup_header():
	header_label.text = "Select {units} for {recipe}".format({
		"units" : recipe.units_label,
		"recipe" : recipe.label,
	})


func _build_requirements():
	for requirement : RecipeIngredient in recipe.ingredients:
		requirement_list.add_item("")
	_update_requirements()


func _update_requirements():
	for i in range(0, len(recipe.ingredients)):
		var requirement : RecipeIngredient = recipe.ingredients[i]
		var items : Array[Item] = []
		for selection in selected_items[i]:
			var item : Item = selection as Item
			if item != null:
				items.append(item)
		
		_update_requirement_text(requirement, items, i)
		_update_requirement_icon(requirement, i)
		_update_requirement_color(requirement, items, i)
	_validate_craft()


func _update_requirement_text(requirement : RecipeIngredient, items : Array[Item], index : int):
	var label : String = requirement.get_recipe_text()
	var completion : String = requirement.counter.get_completion_text(items)
	if not completion.is_empty():
		label = "{label} - {completion}".format({
			"label" : label,
			"completion" : completion,
		})
	requirement_list.set_item_text(index, label)


func _update_requirement_icon(requirement : RecipeIngredient, index : int):
	requirement_list.set_item_icon(index, requirement.icon)


func _update_requirement_color(requirement : RecipeIngredient, items : Array[Item], index : int):
	var color : Color = GameColorUtil.COLOR_NORMAL
	var satisfaction : RecipeIngredientCounter.RecipeSatisfaction
	satisfaction = requirement.counter.is_satisfactory(items)
	match satisfaction:
		RecipeIngredientCounter.RecipeSatisfaction.DEFICIENT:
			color = GameColorUtil.COLOR_WARN_READABLE
		RecipeIngredientCounter.RecipeSatisfaction.SATISFACTORY:
			color = GameColorUtil.COLOR_GOOD_READABLE
		RecipeIngredientCounter.RecipeSatisfaction.EXCESS:
			color = GameColorUtil.COLOR_BAD_READABLE
	requirement_list.set_item_custom_fg_color(index, color)
	requirement_list.set_item_icon_modulate(index, color)


func _validate_craft():
	craft_button.disabled = not _can_craft()


func _can_craft() -> bool:
	for i in range(0, len(recipe.ingredients)):
		var ingredient : RecipeIngredient = recipe.ingredients[i]
		var items : Array[Item] = []
		for selection in selected_items[i]:
			var item : Item = selection as Item
			if item != null:
				items.append(item)
		if not ingredient.is_satisfactory(items):
			return false
	return true


func _find_items():
	available_items = []
	for i in range(0, len(recipe.ingredients)):
		var requirement : RecipeIngredient = recipe.ingredients[i]
		
		var group : Array[Item] = []
		for item : Item in agent.inventory.get_all_contents():
			if requirement.finder.matches_filter(item):
				group.append(item)
		available_items.append(group)
		selected_items.append([])


func _on_requirement_selected(index : int):
	active_index = index
	for child in inventory_list.get_children():
		child.queue_free()
	
	for item : Item in available_items[index]:
		var checkbox : CreatePopupInventoryItem = CreatePopupInventoryItem.new()
		checkbox.item = item
		checkbox.button_pressed = selected_items[index].has(item)
		# HACK: Untested
		checkbox.disabled = all_selections.has(item) and not selected_items[index].has(item)
		_connect_inventory_item(checkbox)
		inventory_list.add_child(checkbox)
	
	if len(available_items[index]) == 0:
		var label : Label = Label.new()
		label.text = "No suitable items"
		inventory_list.add_child(label)
	
	_clear_item_description()


func _connect_inventory_item(item : CreatePopupInventoryItem) -> void:
	item.item_selected.connect(_on_item_selected)
	item.item_deselected.connect(_on_item_deselected)
	item.item_focused.connect(_on_item_focused)


func _on_craft_pressed():
	_finalize_craft()
	queue_free()


func _on_cancel_pressed():
	queue_free()


func _on_item_selected(item : Item):
	if not selected_items[active_index].has(item):
		selected_items[active_index].append(item)
	if not all_selections.has(item):
		all_selections.append(item)
	_update_requirements()


func _on_item_deselected(item : Item):
	if selected_items[active_index].has(item):
		selected_items[active_index].erase(item)
	if all_selections.has(item):
		all_selections.erase(item)
	_update_requirements()


func _on_item_focused(item : Item):
	item.fill_description(item_description, DESCRIPTION_FONT_SIZE_MAIN, DESCRIPTION_FONT_SIZE_EXTRA, DESCRIPTION_ICON_SIZE)

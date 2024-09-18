extends Action


func get_unfinished_items(agent : Agent) -> Array[UnfinishedItem]:
	var items : Array[UnfinishedItem] = []
	for item : Item in agent.inventory.get_all_contents():
		var unfinished : UnfinishedItem = item as UnfinishedItem
		if unfinished != null:
			items.append(unfinished)
	return items


func get_items_craftable_now(agent : Agent) -> Array[UnfinishedItem]:
	var unfinished = get_unfinished_items(agent)
	var items : Array[UnfinishedItem] = []
	for item : UnfinishedItem in unfinished:
		if _has_tool_for(agent, item):
			items.append(item)
	return items


func _has_tool_for(agent : Agent, item : UnfinishedItem) -> bool:
	var tools = agent.inventory.get_best_tools()
	for requirement : RecipeTool in item.recipe.tools:
		var tool : ToolTemplate = requirement.tool
		var power = tools[tool].get_tool_effectiveness(tool) if tools.has(requirement.tool) else 0
		if power >= requirement.min_effectiveness:
			return true
	return false


func has_any_tools(agent : Agent) -> bool:
	return has_any_tools_for(agent, get_unfinished_items(agent))


func has_any_tools_for(agent : Agent, items : Array[UnfinishedItem]) -> bool:
	for item : UnfinishedItem in items:
		if _has_tool_for(agent, item):
			return true
	return false

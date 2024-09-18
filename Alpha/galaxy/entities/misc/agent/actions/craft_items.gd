extends Action


func get_unfinished_items(agent : Agent) -> Array[UnfinishedItem]:
	var items : Array[UnfinishedItem] = []
	for item : Item in agent.inventory.get_all_contents():
		var unfinished : UnfinishedItem = item as UnfinishedItem
		if unfinished != null:
			items.append(unfinished)
	return items


func _has_any_tools_for(agent : Agent, items : Array[UnfinishedItem]) -> bool:
	var tools = agent.inventory.get_best_tools()
	for item : UnfinishedItem in items:
		for requirement : RecipeTool in item.recipe.tools:
			var power = tools[requirement.tool] if tools.has(requirement.tool) else 0
			if power >= requirement.min_effectiveness:
				return true
	return false

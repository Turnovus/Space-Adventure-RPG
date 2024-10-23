extends Action


const BASE_WORK_POINTS : int = 10


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
		if power < requirement.min_effectiveness:
			return false
	return true


func has_any_tools(agent : Agent) -> bool:
	return has_any_tools_for(agent, get_unfinished_items(agent))


func has_any_tools_for(agent : Agent, items : Array[UnfinishedItem]) -> bool:
	for item : UnfinishedItem in items:
		if _has_tool_for(agent, item):
			return true
	return false


func _do_action(agent : Agent, potency : float):
	var best_tools : Dictionary = agent.inventory.get_best_tools()
	#HACK: Work amounts do not reflect actor's actual point utilization
	var physical_work : float = potency * BASE_WORK_POINTS
	var mental_work : float = potency * BASE_WORK_POINTS
	
	for any_item : Item in agent.inventory.get_all_contents():
		var unfinished : UnfinishedItem = any_item as UnfinishedItem
		#HACK: _has_tool_for may be redundant in a loop like this, consider using cache
		if unfinished == null or not _has_tool_for(agent, unfinished):
			continue
		
		var work_effectiveness : float = 1.0
		for tool_template : ToolTemplate in unfinished.recipe.get_required_tools():
			var tool : Item = best_tools[tool_template]
			work_effectiveness *= tool.get_tool_effectiveness(tool_template)
		
		var physical_requirement : float = unfinished.recipe.physical_labor - unfinished.labor_completed_physical
		if physical_requirement > 0:
			var physical_work_possible : float = physical_work * work_effectiveness
			var physical_work_done : float = min(physical_requirement, physical_work_possible)
			unfinished.labor_completed_physical += physical_work_done
			physical_work -= physical_work_done / work_effectiveness
		
		var mental_requirement : float = unfinished.recipe.mental_labor - unfinished.labor_completed_mental
		if mental_requirement > 0:
			var mental_work_possible : float = mental_work * work_effectiveness
			var mental_work_done : float = min(mental_requirement, mental_work_possible)
			unfinished.labor_completed_mental += mental_work_done
			mental_work -= mental_work_done / work_effectiveness
		
		unfinished.update_crafting_progress()
		
		if physical_work <= 0 and mental_work <= 0:
			break

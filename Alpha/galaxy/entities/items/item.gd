class_name Item
extends Entity


const FORMAT_KEY_TOOL : String = "tool"

var label : String
var icon : Texture2D
var description : String

var tools : Dictionary = {}
var is_assembled_tool : bool
var tool_assembly_effect : float = 1

var show_parts : bool = true
var parts_label : String = StringConstantUtil.ITEM_PART_HEADER

var template : ItemTemplate:
	set(new_template):
		if new_template == null:
			push_warning("Attempted to assign null template to item.")
			return
		template = new_template
		_notify_template_changed()


func fill_description(target : RichTextLabel, size_main : int, size_extra : int, size_icon : int) -> void:
	start_description(target, size_main, size_extra)
	fill_tool_description(target, size_icon)
	fill_part_description(target, size_icon)


func start_description(target : RichTextLabel, size_main : int, size_extra : int) -> void:
	target.clear()
	target.push_font_size(size_main)
	target.append_text(description)
	target.push_font_size(size_extra)


## Populates a RichTextLabel with the description and all relevant details of the item.
func fill_tool_description(target : RichTextLabel, size_icon : int) -> void:
	if get_available_tools().is_empty():
		return
	
	target.append_text("\n\nTool properties:")
	target.push_list(1, RichTextLabel.LIST_DOTS, true)
	
	for tool : ToolTemplate in get_available_tools():
		var tool_label : String = tool.label
		var tool_icon : Texture2D = tool.icon
		var tool_effect : float = get_tool_effectiveness(tool)
		target.add_image(tool_icon, size_icon, size_icon)
		target.append_text(tool_label.capitalize())
		target.append_text(" (%s)" % snapped(tool_effect, 0.01))
		target.append_text("\n")
	
	target.pop()


func fill_part_description(target : RichTextLabel, size_icon : int) -> void:
	var parts : Array[Item] = get_parts()
	if parts.is_empty():
		return
	
	target.append_text("\n\n%s:" % parts_label)
	target.push_list(1, RichTextLabel.LIST_DOTS, true)
	for part : Item in parts:
		fill_single_part_description(target, part, size_icon)
	target.pop()


func fill_single_part_description(target : RichTextLabel, part : Item, size_icon : int) -> void:
	target.add_image(part.icon, size_icon, size_icon)
	target.append_text(part.label.capitalize())
	target.append_text("\n")
	#TODO: Nested parts?


func get_available_tools() -> Array[ToolTemplate]:
	var tools_array : Array[ToolTemplate] = []
	for key in tools.keys():
		var tool : ToolTemplate = key as ToolTemplate
		if tool != null:
			tools_array.append(tool)
	return tools_array


func get_tool_effectiveness(tool : ToolTemplate) -> float:
	return tools[tool] if tools.has(tool) else 0


func get_parts() -> Array[Item]:
	var parts : Array[Item] = []
	for child in get_children():
		var item : Item = child as Item
		if item != null:
			parts.append(item)
	return parts


func _notify_template_changed():
	icon = template.icon
	label = template.label
	description = template.description
	show_parts = template.show_parts
	parts_label = template.parts_label
	
	is_assembled_tool = template.is_assembled_tool
	tool_assembly_effect = template.tool_assembly_effect
	_resolve_tools()


func _resolve_tools() -> void:
	tools = {} # {ToolTemplate : float}
	for properties : ToolProperties in template.tool_properties:
		tools[properties.tool] = properties.effectiveness
	
	_resolve_tool_assembly()


func _resolve_tool_assembly() -> void:
	if not is_assembled_tool:
		return
	
	for part : Item in get_parts():
		for part_tool : ToolTemplate in part.tools:
			if not tools.has(part_tool):
				tools[part_tool] = 0
			tools[part_tool] += part.tools[part_tool]
	
	for assembled_tool : ToolTemplate in tools.keys():
		tools[assembled_tool] *= tool_assembly_effect
	
	_resolve_tool_name()


func _resolve_tool_name() -> void:
	var best_tool : ToolTemplate = null
	for tool : ToolTemplate in tools.keys():
		if best_tool == null or tools[tool] > tools[best_tool]:
			best_tool = tool
	
	var tool_name : String = "tool" if best_tool == null else best_tool.finished_tool_name
	label = _do_tool_format(label, tool_name)
	description = _do_tool_format(description, tool_name)


func _do_tool_format(string : String, tool_name : String) -> String:
	return string.format({FORMAT_KEY_TOOL : tool_name})

class_name Item
extends Entity


var label : String
var icon : Texture2D
var template : ItemTemplate:
	set(new_template):
		template = new_template
		_notify_template_changed()
var tools : Dictionary = {}


func fill_description(target : RichTextLabel, size_main : int, size_extra : int, size_icon : int) -> void:
	target.clear()
	target.push_font_size(size_main)
	target.append_text(template.description)
	target.push_font_size(size_extra)
	fill_tool_description(target, size_icon)


func fill_tool_description(target : RichTextLabel, size_icon : int):
	if get_available_tools().is_empty():
		return
	
	target.append_text("\n\nTool properties:")
	target.push_list(1, RichTextLabel.LIST_DOTS, true)
	
	for tool : ToolTemplate in get_available_tools():
		var tool_label : String = tool.label
		var tool_icon : Texture2D = tool.icon
		var tool_effect : float = get_tool_effectiveness(tool)
		target.add_image(tool_icon, size_icon, size_icon)
		target.append_text(tool_label)
		target.append_text(" (%s)" % snapped(tool_effect, 0.01))
	
	target.pop()


func get_available_tools() -> Array[ToolTemplate]:
	var tools_array : Array[ToolTemplate] = []
	for key in tools.keys():
		var tool : ToolTemplate = key as ToolTemplate
		if tool != null:
			tools_array.append(tool)
	return tools_array


func get_tool_effectiveness(tool : ToolTemplate) -> float:
	return tools[tool] if tools.has(tool) else 0


func _notify_template_changed():
	icon = template.icon
	label = template.label
	_resolve_tools()


func _resolve_tools():
	tools = {}
	for properties : ToolProperties in template.tool_properties:
		tools[properties.tool] = properties.effectiveness

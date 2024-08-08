class_name Item
extends Entity


var label : String
var icon : Texture2D
var template : ItemTemplate:
	set(new_template):
		template = new_template
		_notify_template_changed()
var tools : Dictionary = {}


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

class_name Item
extends Entity


var label : String
var icon : Texture2D
var template : ItemTemplate:
	set(new_template):
		template = new_template
		_notify_template_changed()


func _notify_template_changed():
	icon = template.icon
	label = template.label

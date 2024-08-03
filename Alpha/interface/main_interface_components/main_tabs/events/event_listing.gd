class_name EventListing
extends PanelContainer


var format_rules = {
	"name" : Callable(resolve_name),
	"possessive" : Callable(resolve_possessive),
}

@onready var icon_major : TextureRect = $HBoxContainer/Icons/MajorIcon
@onready var icon_minor : TextureRect = $HBoxContainer/Icons/MinorIcon
@onready var label_title : Label = $HBoxContainer/Text/Title
@onready var label_description : Label = $HBoxContainer/Text/Description
@onready var color_strip : ColorRect = $HBoxContainer/ColorRect
@onready var delete_button : Button = $HBoxContainer/DeleteButton


func _ready():
	delete_button.pressed.connect(_on_delete_pressed)


func set_event(type : EventType, targets : Array):
	if type.default_icon_primary != null:
		icon_major.texture = type.default_icon_primary
	
	if type.default_icon_secondary != null:
		icon_minor.texture = type.default_icon_secondary
	
	label_title.text = resolve_text(type.label_format, targets)
	label_description.text = resolve_text(type.description_format, targets)
	
	color_strip.color = type.color


func resolve_text(format : String, targets : Array) -> String:
	for i in range(len(targets)):
		for key in format_rules.keys():
			var infix = str(i) + "." + key
			var value = format_rules[key].call(targets[i])
			format = format.format({infix : value})
	
	return format


# HACK: Low cohesion design
func resolve_name(target) -> String:
	var galaxy : Galaxy = get_tree().root.get_child(0).get_galaxy()
	var player = galaxy.player
	
	if target == player:
		return "you" #TODO: incorporate agent identity
	
	var label : String = target.get("label") as String
	if label != null:
		return label
	
	return "something"


func resolve_possessive(target) -> String:
	var galaxy : Galaxy = get_tree().root.get_child(0).get_galaxy()
	var player = galaxy.player
	if target == player:
		return "your" #TODO: Incorporate agent identity
	
	return "its"


func _on_delete_pressed():
	queue_free()

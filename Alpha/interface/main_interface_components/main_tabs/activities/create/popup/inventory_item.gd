class_name CreatePopupInventoryItem
extends CheckBox


signal item_selected(item : Item)
signal item_deselected(item : Item)


var item : Item:
	set(new_item):
		item = new_item
		text = item.label.capitalize()
		icon = item.icon


func _ready():
	toggled.connect(_on_toggled)
	expand_icon = true


func _on_toggled(toggled_on : bool):
	if toggled_on:
		item_selected.emit(item)
	else:
		item_deselected.emit(item)

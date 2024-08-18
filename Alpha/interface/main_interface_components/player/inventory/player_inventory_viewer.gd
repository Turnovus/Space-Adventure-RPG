extends HBoxContainer


const DESCRIPTION_FONT_SIZE_MAIN = 20
const DESCRIPTION_FONT_SIZE_EXTRA = 15

const ICON_SIZE_TOOL = 20

@export var fallback_texture : Texture2D

var inventory : Inventory
var list_root : TreeItem
var selected_item : Item
var tree_items : Array

@onready var item_list : Tree = $ListScroll/ItemList
@onready var item_panel = $ItemPanel/VBoxContainer

@onready var item_icon : TextureRect = $ItemPanel/VBoxContainer/HBoxContainer/ItemIcon
@onready var item_label : Label = $ItemPanel/VBoxContainer/HBoxContainer/ItemLabel

@onready var item_data : RichTextLabel = $ItemPanel/VBoxContainer/ItemData


func _ready():
	var player : Agent = await ReferenceSingleton.get_player()
	inventory = player.inventory
	inventory.child_entered_tree.connect(_on_inventory_modified)
	inventory.child_exiting_tree.connect(_on_inventory_modified)
	inventory.child_order_changed.connect(_on_inventory_reordered)
	item_list.item_selected.connect(_on_item_selected)
	
	update()


func update():
	rebuild_item_tree()
	validate_selection()
	update_item_panel()


func rebuild_item_tree():
	item_list.clear()
	list_root = item_list.create_item()
	tree_items = []
	
	for child in inventory.get_children():
		var item : Item = child as Item
		if item == null:
			continue
		
		var list_item : TreeItem = item_list.create_item(list_root)
		var icon : Texture2D = fallback_texture if item.icon == null else item.icon
		list_item.set_icon(0, icon)
		list_item.set_text(0, item.label.capitalize())
		list_item.set_icon_max_width(0, 24)
		
		tree_items.append(list_item)


func validate_selection():
	if is_selection_invalid():
		selected_item = null


func is_selection_invalid() -> bool:
	if selected_item == null:
		return false
	if selected_item.is_queued_for_deletion():
		return true
	if selected_item.get_parent() != inventory:
		return true
	
	return false


func update_item_panel():
	if selected_item == null:
		item_panel.hide()
		return
	
	item_panel.show()
	var icon : Texture2D = fallback_texture if selected_item.icon == null else selected_item.icon
	item_icon.texture = icon
	item_label.text = selected_item.label.capitalize()
	selected_item.fill_description(item_data, DESCRIPTION_FONT_SIZE_MAIN, DESCRIPTION_FONT_SIZE_EXTRA, ICON_SIZE_TOOL)


func _on_inventory_modified(_node : Node):
	update()


func _on_inventory_reordered():
	update()


func _on_item_selected():
	var tree_selection = item_list.get_selected()
	if tree_selection == null:
		selected_item = null
		update_item_panel()
		return
	
	var index : int = tree_items.find(tree_selection)
	if index < 0:
		selected_item = null
		update_item_panel()
		return
	
	selected_item = inventory.get_child(index) #HACK: does not account for non-item children
	update_item_panel()

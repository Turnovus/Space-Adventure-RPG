extends HBoxContainer


@export var galaxy_texture : Texture2D

var tree_root : TreeItem
var references : Dictionary = {}

@onready var tree : Tree = $Tree


func _ready():
	tree_root = tree.create_item()
	tree_root.set_text(0, "The Galaxy")
	tree_root.set_icon(0, galaxy_texture)
	tree_root.set_icon_max_width(0, 24)
	
	var galaxy : Galaxy = get_tree().root.get_child(0).get_galaxy()
	var player : Agent = galaxy.player
	player.codex.entry_pushed.connect(_on_player_entry_pushed)


func push_codex_entry(entry : CodexEntry):
	var item
	if references.has(entry.reference):
		item = references[entry.reference]
	else:
		item = create_entry(entry)
	
	update_entry(entry, item)


func create_entry(entry : CodexEntry) -> TreeItem:
	var parent = references[entry.reference.get_parent()] if references.has(entry.reference.get_parent()) else tree_root
	var item = tree.create_item(parent)
	references[entry.reference] = item
	
	return item


func update_entry(entry : CodexEntry, item : TreeItem):
	item.set_text(0, Identity.get_title(entry.identity).capitalize())
	item.set_icon(0, entry.identity.default_codex_icon)
	item.set_icon_max_width(0, 24)


func _on_player_entry_pushed(entry : CodexEntry):
	push_codex_entry(entry)

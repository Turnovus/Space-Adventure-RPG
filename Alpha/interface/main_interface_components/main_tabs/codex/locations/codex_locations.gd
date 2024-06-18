extends HBoxContainer


@export var galaxy_texture : Texture2D

var tree_root : TreeItem
var references : Dictionary = {}
var codex : Codex

@onready var tree : Tree = $Tree


func _ready():
	var galaxy : Galaxy = get_tree().root.get_child(0).get_galaxy()
	var player : Agent = galaxy.player
	codex = galaxy.player.codex
	codex.entry_pushed.connect(_on_player_entry_pushed)
	rebuild_codex()


func push_codex_entry(entry : CodexEntry, validate_hiearcy : bool = true):
	if not codex_concerns(entry.reference):
		return
	
	var item
	if references.has(entry.reference):
		item = references[entry.reference]
	else:
		item = create_entry(entry)
	
	update_entry(entry, item)
	if validate_hiearcy:
		validate_tree_hiearchy(entry)


func create_entry(entry : CodexEntry) -> TreeItem:
	var parent = references[entry.reference.get_parent()] if references.has(entry.reference.get_parent()) else tree_root
	var item = tree.create_item(parent)
	references[entry.reference] = item
		
	return item


func update_entry(entry : CodexEntry, item : TreeItem):
	item.set_text(0, Identity.get_title(entry.identity).capitalize())
	item.set_icon(0, entry.identity.default_codex_icon)
	item.set_icon_max_width(0, 24)


func codex_concerns(node : Node) -> bool:
	return node is Sun or node is TerrestrialLocation


func rebuild_codex():
	initialize_tree_control()
	references = {}
	
	var entries = []
	var uncached_references = []
	for entry : CodexEntry in codex.get_entries():
		if codex_concerns(entry.reference):
			entries.append(entry)
			uncached_references.append(entry.reference)
	
	while len(entries) > 0:
		for index in range(len(entries) - 1, -1, -1):
			var entry : CodexEntry = entries[index]
			if uncached_references.has(entry.reference.get_parent()):
				continue
			
			push_codex_entry(entry, false)
			entries.remove_at(index)
			uncached_references.remove_at(index)


func initialize_tree_control():
	tree.clear()
	tree_root = tree.create_item()
	tree_root.set_text(0, "The Galaxy")
	tree_root.set_icon(0, galaxy_texture)
	tree_root.set_icon_max_width(0, 24)


## If parent entities are added after their children, then they will need to be
## reorganized into the proper hiearchy. This method will check if the hiearchy
## has been violated, and will rebuild the codex tree if necessary.
func validate_tree_hiearchy(last_addition : CodexEntry):
	var valid = true
	for reference in references.keys():
		var parent = reference.get_parent()
		if parent != null and parent == last_addition.reference:
			valid = false
			break
	
	if not valid:
		rebuild_codex()


func _on_player_entry_pushed(entry : CodexEntry):
	push_codex_entry(entry)

class_name CodexEntry
extends Node


var reference : Node
var identity : Identity
var known_details : Codex.CodexDetails


func _init(new_reference : Node, initial_details : Codex.CodexDetails):
	reference = new_reference
	known_details = initial_details
	
	reference.tree_exiting.connect(_on_reference_deleted)
	reference.property_list_changed.connect(_on_reference_altered)
	
	update_identity()


func update_identity():
	if identity == null:
		identity = Identity.new(false)
	
	var reference_identity = get_reference_identity()
	
	identity.default_codex_icon = reference_identity.default_codex_icon
	var knows_title = known_details & Codex.CodexDetails.TITLE
	identity.title = Identity.get_title(reference_identity, knows_title)
	var knows_gender = known_details & Codex.CodexDetails.GENDER
	identity.gender = Identity.get_gender(reference_identity, knows_gender)


func get_reference_identity() -> Identity:
	return reference.get_identity() if reference.has_method("get_identity") else null


func _on_reference_deleted():
	reference = null


func _on_reference_altered():
	update_identity()

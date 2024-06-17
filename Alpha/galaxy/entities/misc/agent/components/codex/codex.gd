class_name Codex
extends Node


enum CodexDetails {
	NOTHING = 0b0000_0000,
	
	TITLE = 0b0000_0001,
	GENDER = 0b0000_0010,
	LOCATION = 0b0000_0100,
	
	EVERYTHING = 0b0000_0111,
}

signal entry_pushed(entry : CodexEntry)


func get_entries() -> Array[CodexEntry]:
	var entries : Array[CodexEntry] = []
	for child in get_children():
		if child is CodexEntry:
			entries.append(child)
	return entries


func push_entry(reference : Node, new_details : int):
	var entry = null
	for child in get_entries():
		if child.reference == reference:
			entry = child
			break
	
	if entry == null:
		entry = CodexEntry.new(reference, new_details)
		add_child(entry)
		entry_pushed.emit(entry)
		return
	
	entry.known_details |= new_details
	entry_pushed.emit(entry)


func knows_title(reference : Node) -> bool:
	for entry in get_entries():
		if entry.reference == reference:
			return CodexDetails.TITLE & entry.known_details
	return false


func knows_about(reference : Node, details : CodexDetails) -> bool:
	for entry in get_entries():
		if entry.reference == reference:
			return details & entry.known_details
	return false

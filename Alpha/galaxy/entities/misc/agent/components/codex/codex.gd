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

const DETAIL_NAMES = {
	CodexDetails.TITLE : "name",
	CodexDetails.GENDER : "gender",
	CodexDetails.LOCATION : "location",
}

@export var entry_updated_event : EventType


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
		try_notify_discoveries(entry, new_details)
		return
	
	var unknown_details = entry.known_details ^ new_details
	entry.known_details |= new_details
	entry.update_identity()
	entry_pushed.emit(entry)
	try_notify_discoveries(entry, unknown_details)


func try_notify_discoveries(entry : CodexEntry, details : int):
	var galaxy : Galaxy = await ReferenceSingleton.get_galaxy()
	for key in DETAIL_NAMES.keys():
		if key & details > 0:
			var known_title = Identity.get_title(entry.reference.get_identity(), knows_title(entry.reference))
			galaxy.push_event(entry_updated_event, [get_parent(), known_title, DETAIL_NAMES[key]])


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

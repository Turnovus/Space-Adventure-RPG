class_name ActionList
extends VBoxContainer

const LISTING = preload("res://interface/main_interface_components/action_listing/action_listing.tscn")

@export var mode : ActionListing.ActionListingMode

@onready var galaxy : Galaxy = get_tree().root.get_child(0).get_galaxy()


func update(doers : Array[ActionDoer]):
	var missing_doers = doers.duplicate()
	var extra_listings = []
	for child in get_children():
		var listing : ActionListing = child as ActionListing
		if listing == null:
			continue
		
		if missing_doers.has(listing.doer):
			missing_doers.erase(listing.doer)
		else:
			extra_listings.append(listing)
	
	for i in range(get_child_count() - 1, -1, -1):
		var child = get_child(i)
		if extra_listings.has(child):
			extra_listings.erase(child)
			child.queue_free()
	
	for missing in missing_doers:
		create_listing(missing)


func update_listing_visibility_for(agent : Agent):
	for child in get_children():
		var listing : ActionListing = child as ActionListing
		if listing == null:
			continue
		listing.visible = not agent.is_already_doing(listing.doer)


func create_listing(doer : ActionDoer):
	var listing : ActionListing = LISTING.instantiate()
	listing.doer = doer
	listing.mode = mode
	add_child(listing)
	listing.update()

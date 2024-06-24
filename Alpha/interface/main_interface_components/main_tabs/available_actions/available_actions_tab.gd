extends ScrollContainer


const LISTING = preload("res://interface/main_interface_components/action_listing/action_listing.tscn")


func update(doers : Array[ActionDoer]):
	var missing_doers = doers.duplicate()
	var extra_listings = []
	for child in get_children():
		var listing : ActionListing = child as ActionListing
		if listing == null:
			continue
		
		#TODO
	
	for i in range(get_child_count() - 1, -1, -1):
		if extra_listings.has(get_child(i)):
			get_child(i).queue_free()
	
	for missing in missing_doers:
		create_listing(missing)


func create_listing(doer : ActionDoer):
	var listing : ActionListing = LISTING.instantiate()

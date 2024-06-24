extends ScrollContainer


const LISTING = preload("res://interface/main_interface_components/action_listing/action_listing.tscn")

@onready var container : VBoxContainer = $VBoxContainer
@onready var galaxy : Galaxy = get_tree().root.get_child(0).get_galaxy()


func _ready():
	galaxy.turn_post.connect(_on_turn_post)
	galaxy.player_actions_changed.connect(_on_player_actions_changed)
	
	update(galaxy.player.get_doable_actions())


func update(doers : Array[ActionDoer]):
	var missing_doers = doers.duplicate()
	var extra_listings = []
	for child in container.get_children():
		var listing : ActionListing = child as ActionListing
		if listing == null:
			continue
		
		if missing_doers.has(listing.doer):
			missing_doers.erase(listing.doer)
		else:
			extra_listings.append(listing)
	
	for i in range(container.get_child_count() - 1, -1, -1):
		var child = container.get_child(i)
		if extra_listings.has(child):
			extra_listings.erase(child)
			child.queue_free()
	
	for missing in missing_doers:
		create_listing(missing)


func create_listing(doer : ActionDoer):
	var listing : ActionListing = LISTING.instantiate()
	listing.doer = doer
	container.add_child(listing)
	listing.update()


func _on_turn_post(_turn : int):
	update(galaxy.player.get_doable_actions())


func _on_player_actions_changed():
	update(galaxy.player.get_doable_actions())

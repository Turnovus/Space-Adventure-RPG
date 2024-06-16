class_name Planet
extends TerrestrialLocation


const BASE_PLANET_SIZE : Vector2 = Vector2(100, 100)

var size: float = 1
var day_length_turns : int
var day_progress_turns : int


func _init():
	size = randi_range(6, 14) / 10.0
	day_length_turns = randi_range(6, 18) * 20
	day_progress_turns = randi_range(0, day_length_turns - 1)


func add_child_entity(entity: Entity):
	super(entity)
	entity.location_changed.connect(_on_child_location_changed)
	entity.location_relative = normalized_relative_location(entity.location_relative)
	
	var codex : Codex = entity.get_node_or_null("Codex")
	if codex != null:
		codex.push_entry(get_parent(), Codex.CodexDetails.TITLE)
		codex.push_entry(self, Codex.CodexDetails.TITLE)
	
	var agent : Agent = entity as Agent
	if agent != null:
		scan_sites(agent)


func remove_child_entity(entity: Entity):
	super(entity)
	entity.location_changed.disconnect(_on_child_location_changed)


func normalized_relative_location(location: Vector2) -> Vector2:
	var normalized = Vector2(location)
	
	# Moving horizantally is wrapped
	var max_x = get_size().x * 0.5
	while normalized.x > max_x:
		normalized.x -= max_x * 2
	while normalized.x < -(max_x):
		normalized.x += max_x * 2
	
	# Moving vertically is clamped
	var max_y = get_size().y * size * 0.5
	normalized.y = clampf(normalized.y, -max_y, max_y)
	
	return normalized


func get_size() -> Vector2:
	return BASE_PLANET_SIZE * size


func time_of_day_at(relative_location : Vector2) -> float:
	var global_time : float = float(day_progress_turns) / day_length_turns
	#return global_time
	var total_width = BASE_PLANET_SIZE.x * size
	var offset = relative_location.x / total_width
	var local_time = global_time + offset # NOTE: This assumes that the sun rises in the east and sets in west
	var mod = fmod(local_time, 1.0)
	if local_time < 0:
		mod = 1 - abs(mod)
	return mod


func light_level_at(relative_location : Vector2) -> float:
	#NOTE: Remember to rewrite comment after tampering with equation
	#f(x) = -10(x-0.55)^2 + 1.2 {0 <= f(x) <= 1}
	#0.55 = midday
	var time = time_of_day_at(relative_location)
	var light = time - 0.55
	light *= light
	light *= -10
	light += 1.2
	return clampf(light, 0, 1)


func get_random_location() -> Vector2:
	var dimensions = get_size()
	dimensions -= dimensions / 2
	var random = dimensions
	random.x *= randf_range(-1, 1)
	random.y *= randf_range(-1, 1)
	return random


func scan_sites(agent : Agent):
	for child in get_children():
		var site : Site = child as Site
		if site == null:
			continue
		
		var detection = agent.get_detection_range() * site.get_detection_range_factor()
		#HACK: Detection does not wrap around planet
		if agent.location_relative.distance_to(site.location_relative) <= detection:
			agent.codex.push_entry(site, Codex.CodexDetails.LOCATION)


func _turn_action(turn: int):
	super(turn)
	
	day_progress_turns += 1
	if day_progress_turns >= day_length_turns:
		day_progress_turns -= day_length_turns


func _on_child_location_changed(entity: Entity):
	entity.location_relative = normalized_relative_location(entity.location_relative)
	
	var agent : Agent = entity as Agent
	if agent != null:
		scan_sites(agent)

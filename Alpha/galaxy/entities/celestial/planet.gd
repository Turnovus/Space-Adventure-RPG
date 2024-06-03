extends Entity
class_name Planet


const BASE_PLANET_SIZE : Vector2 = Vector2(100, 50)

var size: float = 1


func add_child_entity(entity: Entity):
	super(entity)
	entity.location_changed.connect(_on_child_location_changed)
	entity.location_relative = normalized_relative_location(entity.location_relative)


func remove_child_entity(entity: Entity):
	super(entity)
	entity.location_changed.disconnect(_on_child_location_changed)


func normalized_relative_location(location: Vector2) -> Vector2:
	var normalized = Vector2(location)
	
	var max_x = BASE_PLANET_SIZE.x * size * 0.5
	normalized.x = clampf(normalized.x, -max_x, max_x)
	
	var max_y = BASE_PLANET_SIZE.y * size * 0.5
	normalized.y = clampf(normalized.y, -max_y, max_y)
	
	return normalized


func get_size() -> Vector2:
	return BASE_PLANET_SIZE * size


func _turn_action():
	super()


func _on_child_location_changed(entity: Entity):
	entity.location_relative = normalized_relative_location(entity.location_relative)

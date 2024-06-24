class_name Entity
extends Node


signal location_changed(this : Entity)

var turn_created = 0
var location_relative : Vector2 = Vector2(0,0)


func _ready():
	var galaxy : Galaxy = get_tree().root.get_child(0).get_galaxy()
	turn_created = galaxy.turn


func add_child_entity(entity: Entity):
	var parent = entity.get_parent()
	if parent != null:
		var parent_entity : Entity = parent as Entity
		if parent_entity == null:
			parent.remove_child(entity)
		else:
			parent_entity.remove_child_entity(entity)
	
	add_child(entity)


func remove_child_entity(entity: Entity):
	remove_child(entity)


func move_relative(movement : Vector2):
	location_relative = location_relative + movement


func set_location_relative(value : Vector2):
	location_relative = value
	location_changed.emit(self)


func do_turn(turn : int):
	_turn_action(turn)
	
	for child : Node in get_children():
		if child is Entity:
			child.do_turn(turn)


func get_identity() -> Identity:
	for child in get_children():
		if child is Identity:
			return child
	return null


func get_action_doers() -> Array[ActionDoer]:
	var doers : Array[ActionDoer] = []
	for child in get_children():
		var issuer : ActionIssuer = child as ActionIssuer
		if issuer != null:
			doers.append(issuer.get_doer())
	return doers


func _turn_action(_turn : int):
	pass

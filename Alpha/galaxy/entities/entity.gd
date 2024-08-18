@icon("res://assets/textures/object/cube.svg")
class_name Entity
extends Node


signal location_changed(this : Entity)

var turn_created = 0
var location_relative : Vector2 = Vector2(0,0)


func _ready():
	var galaxy : Galaxy = await ReferenceSingleton.get_galaxy()
	turn_created = galaxy.turn


## Add an entity as a child of this entity. Handles reparenting automatically, safely removing
## the entity from its former parent entity if necessary.
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


func get_outgoing_actions_for(agent_requesting : Agent) -> Array[Action]:
	var actions : Array[Action] = []
	for child in get_children():
		var issuer : ActionIssuer = child as ActionIssuer
		if issuer == null: 
			continue
		var action : Action = issuer.issue_action(agent_requesting)
		if action != null:
			actions.append(action)
	return actions


func get_available_actions() -> Array[Action]:
	var actions : Array[Action] = []
	
	actions.append_array(get_outgoing_actions_for(self))
	actions.append_array(get_parent().get_outgoing_actions_for(self))
	
	return actions


func move_relative(movement : Vector2):
	set_location_relative(location_relative + movement)


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


func _turn_action(_turn : int):
	pass

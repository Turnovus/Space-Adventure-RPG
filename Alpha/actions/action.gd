@icon("res://assets/textures/body/jump-across.svg")
class_name Action
extends Node
## Represents an action performed by an [Agent] over one or more turns.
##
## Actions store the parameters selected by the performing [Agent], and handle the execution of
## action logic, including logic contained in every child [ActionComponent]. Actions are created by
## an [ActionIssuer] attached to an [Entity], and they are handled by the executing agent's
## [ActionManager].


@export var icon : Texture2D
@export var label : String
@export var base_potency : float = 1

var issuer : Node


func get_components() -> Array[ActionComponent]:
	var components : Array[ActionComponent] = []
	for child in get_children():
		var component = child as ActionComponent
		if component != null:
			components.append(component)
			components.append_array(component.get_sub_components())
	return components


func get_physical_point_cost(agent : Agent) -> int:
	var cost = 0
	for component in get_components():
		cost = component.affect_physical_point_cost(cost, agent)
	return cost


func get_mental_point_cost(agent : Agent) -> int:
	var cost = 0
	for component in get_components():
		cost = component.affect_mental_point_cost(cost, agent)
	return cost


func get_potency(agent : Agent) -> float:
	var potency = base_potency
	for component in get_components():
		potency = component.affect_potency(potency, agent)
	return potency


func is_possible_for(agent : Agent) -> bool:
	for component : ActionComponent in get_components():
		if not component.action_possible(agent):
			return false
	
	return true


func is_exclusive_with(other : Action) -> bool:
	if other.scene_file_path == scene_file_path and other.issuer == issuer:
		return true
	
	return false


func action_turn(agent : Agent):
	var potency = get_potency(agent)
	_do_action(agent)
	
	for component in get_components():
		component.turn_action(agent, potency)


func sustain_action(_agent : Agent) -> bool:
	return true


func _do_action(_agent : Agent):
	pass

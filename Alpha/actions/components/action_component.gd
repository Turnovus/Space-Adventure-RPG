class_name ActionComponent
extends Node


@export var view_component : PackedScene


func build_view_component() -> Control:
	if view_component == null:
		return null
	
	return view_component.instantiate() as Control


func affect_physical_point_cost(initial_cost : int, _agent : Agent) -> int:
	return initial_cost


func affect_mental_point_cost(initial_cost : int, _agent : Agent) -> int:
	return initial_cost


func affect_potency(initial_potency : float, _agent : Agent) -> float:
	return initial_potency


func active() -> bool:
	return true


func get_sub_components() -> Array[ActionComponent]:
	var sub_components : Array[ActionComponent] = []
	
	for child in get_children():
		if child is ActionComponent:
			sub_components.append(child)
			sub_components.append_array(child.get_sub_components())
	
	return sub_components


func turn_action(_agent : Agent, _potency : float):
	pass

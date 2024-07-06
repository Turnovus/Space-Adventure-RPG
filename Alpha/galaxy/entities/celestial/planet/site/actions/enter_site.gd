extends Action


func sustain_action(_agent : Agent) -> bool:
	return false


func _do_action(agent : Agent):
	issuer.add_child_entity(agent)
	agent.location_relative = issuer.location_relative

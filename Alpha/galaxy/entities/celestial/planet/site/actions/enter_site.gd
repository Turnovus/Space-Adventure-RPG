extends Action


func action_turn(agent : Agent):
	issuer.add_child_entity(agent)
	agent.location_relative = issuer.location_relative


func sustain_action(_agent : Agent) -> bool:
	return false

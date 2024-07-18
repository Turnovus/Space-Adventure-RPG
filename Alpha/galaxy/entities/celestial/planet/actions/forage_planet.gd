extends Action


func sustain_action(agent : Agent) -> bool:
	return agent.get_parent() == issuer

extends Action


func sustain_action(_agent : Agent) -> bool:
	print("enter_site.sustain_action")
	return false


func _do_action(agent : Agent):
	issuer.add_child_entity(agent)
	agent.location_relative = issuer.location_relative

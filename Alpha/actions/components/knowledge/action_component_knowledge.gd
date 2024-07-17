class_name ActionComponentKnowledge
extends ActionComponent


@export var required_knowledge : Knowledge


func action_possible(agent : Agent) -> bool:
	return agent.knowledge.has_learned(required_knowledge)

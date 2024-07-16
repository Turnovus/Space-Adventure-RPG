class_name ActionComponentTagger
extends ActionComponent


enum ActionTagType {
	IGNORE,
	BLOCK,
	REQUIRE,
}


@export var tag : String
@export var push_tag : bool = true
@export var mode : ActionTagType = ActionTagType.IGNORE


func action_possible(agent : Agent) -> bool:
	if mode == ActionTagType.IGNORE:
		return true
	
	for action : Action in agent.actions.get_actions():
		if action == get_parent():
			continue
		
		for component : ActionComponent in action.get_components():
			var other = component as ActionComponentTagger
			if other == null or other.tag != tag or not other.push_tag:
				continue
			
			return false if mode == ActionTagType.BLOCK else true
	
	return false if mode == ActionTagType.REQUIRE else true

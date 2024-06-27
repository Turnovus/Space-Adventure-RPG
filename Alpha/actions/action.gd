class_name Action
extends Resource


const PARAMETER_POINT_COST_PHYSICAL = "physical points"
const PARAMETER_POINT_COST_MENTAL = "mental points"

@export var base_label : String
@export var icon : Texture2D
@export var components : Array[ActionComponent] = []


func create_doer(issuer : Entity) -> ActionDoer:
	return ActionDoer.new(self, issuer)


func get_parameters(doer : ActionDoer, preview_agent : Agent = null) -> Dictionary:
	var parameters = {
		PARAMETER_POINT_COST_PHYSICAL : 0,
		PARAMETER_POINT_COST_MENTAL : 0,
	}
	
	for component in components:
		component.modify_parameters(parameters, doer, preview_agent)
	
	return parameters

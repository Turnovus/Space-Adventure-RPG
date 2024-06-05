extends Node
class_name Condition


@export var degrees : Array[ConditionDegreeData] = []


var degree = 0


func update(agent : Agent):
	pass


func current_degree() -> ConditionDegreeData:
	if degree < 0 or degree > len(degrees) - 1:
		return null
	return degrees[degree]

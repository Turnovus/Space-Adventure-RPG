extends ActionExclusion
class_name ActionExclusionTag


@export var tag:String


func is_exclusive_with(other : Action) -> bool:
	for child in other.get_children():
		if child is ActionExclusionTag and child.tag == tag:
			return true
	return false

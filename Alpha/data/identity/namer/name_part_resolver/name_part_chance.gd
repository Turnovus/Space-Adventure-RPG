class_name NamePartResolverChance
extends NamePartResolver


@export var child : NamePartResolver
@export_range(0, 1, 0.01) var chance : float


func resolve_name_part(asker : Object) -> String:
	if randf_range(0, 1) <= chance:
		return child.resolve_name_part(asker)
	return ""

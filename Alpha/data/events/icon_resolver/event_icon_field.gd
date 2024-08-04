class_name EventIconResolverField
extends EventIconResolver


@export var field_name : String


func resolve_icon(target) -> Texture2D:
	return target.get(field_name) as Texture2D

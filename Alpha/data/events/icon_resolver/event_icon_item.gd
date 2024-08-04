class_name EventIconResolverItem
extends EventIconResolver


func resolve_icon(target) -> Texture2D:
	var item : Item = target as Item
	return item.icon if item != null else null

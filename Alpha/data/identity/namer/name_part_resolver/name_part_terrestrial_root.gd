class_name NamePartResolverTerrestrialRoot
extends NamePartResolver


@export var fallback_use_node_name : bool = true


func resolve_name_part(asker : Object) -> String:
	var asker_location = asker as TerrestrialLocation
	if asker_location == null:
		return "undefined"
	
	var root = asker_location.get_root_terrestrial_location()
	if root == null:
		return "undefined"
	
	var root_identity : Identity = root.get_identity()
	if root_identity != null:
		return root_identity.title
	
	return root.name if fallback_use_node_name else "undefined"

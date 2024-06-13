class_name Namer
extends Resource


@export var name_parts : Array[NamePartResolver] = []


func resolve_name(asker) -> String:
	var name = ""
	
	for resolver in name_parts:
		var part = resolver.resolve_name_part(asker)
		if not part.is_empty():
			name += part + " "
	
	return name.strip_edges()

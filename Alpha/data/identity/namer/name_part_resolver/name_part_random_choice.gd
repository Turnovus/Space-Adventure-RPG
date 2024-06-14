class_name NamePartResolverRandomChoice
extends NamePartResolver


@export var sub_resolvers : Array[NamePartResolver]
@export_range(0, 100) var selections = 1


func resolve_name_part(asker : Object) -> String:
	var string = ""
	
	var unused = sub_resolvers.duplicate()
	for i in range(0, selections):
		if len(unused) <= 0:
			break
		
		var index = randi_range(0, len(unused) - 1)
		var resolver = unused.pop_at(index)
		string += resolver.resolve_name_part(asker) + " "
	
	return string.strip_edges()

class_name NamePartResolverFromFile
extends NamePartResolver


@export_file("*.txt") var file_path : String


func resolve_name_part(_asker : Object) -> String:
	var file = FileAccess.open(file_path, FileAccess.READ)
	var text = file.get_as_text()
	var options : Array = text.split("\n", false)
	var index = randi_range(0, len(options) - 1)
	return options[index]

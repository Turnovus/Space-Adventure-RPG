class_name EventType
extends Resource


@export var label_format : String
@export_multiline var description_format : String
@export var color : Color
@export_subgroup("icons")
@export var default_icon_primary : Texture2D
@export var icon_primary_resolver : EventIconResolver
@export var default_icon_secondary : Texture2D
@export var icon_secondary_resolver : EventIconResolver


func get_primary_icon(targets : Array) -> Texture2D:
	var icon = null
	if icon_primary_resolver != null:
		icon = icon_primary_resolver.resolve_icon(targets[icon_primary_resolver.target_index])
	return icon if icon != null else default_icon_primary


func get_secondary_icon(targets : Array) -> Texture2D:
	var icon = null
	if icon_secondary_resolver != null:
		icon = icon_secondary_resolver.resolve_icon(targets[icon_secondary_resolver.target_index])
	return icon if icon != null else default_icon_secondary

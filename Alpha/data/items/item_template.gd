class_name ItemTemplate
extends Resource


@export var label : String
@export_multiline var description : String
@export var icon : Texture2D
@export_subgroup("tool")
@export var tool_properties : Array[ToolProperties]
@export_subgroup("parts")
@export var show_parts : bool = true
@export var parts_label : String = StringConstantUtil.ITEM_PART_HEADER

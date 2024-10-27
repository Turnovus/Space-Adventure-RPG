class_name ItemTemplate
extends Resource


@export var label : String
@export_multiline var description : String
@export var icon : Texture2D
@export_subgroup("tool")
@export var tool_properties : Array[ToolProperties]
@export var is_assembled_tool : bool
@export var tool_assembly_effect : float = 1
@export_subgroup("parts")
@export var show_parts : bool = true
@export var parts_label : String = StringConstantUtil.ITEM_PART_HEADER

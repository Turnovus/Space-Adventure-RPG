@icon("res://assets/head/idea.svg")
class_name Knowledge
extends Resource


const COLOR_LEARNED : Color = Color.WHITE
const COLOR_LEARNED_ALT : Color = Color.DARK_SEA_GREEN
const COLOR_CAN_LEARN : Color = Color.CADET_BLUE
const COLOR_LOCKED : Color = Color.RED

@export_group("Info")
@export var key : String
@export var label : String
@export_multiline var description : String
@export var icon : Texture2D

@export_group("Learning")
@export var base_cost : float = 1
@export var prerequisites : Array[Knowledge] = []

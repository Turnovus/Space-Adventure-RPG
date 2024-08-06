@icon("res://assets/textures/head/idea.svg")
class_name Knowledge
extends Resource


const COLOR_LEARNED : Color = GameColorUtil.COLOR_NORMAL
const COLOR_LEARNED_ALT : Color = GameColorUtil.COLOR_GOOD_READABLE
const COLOR_CAN_LEARN : Color = GameColorUtil.COLOR_POSSIBILITY_READABLE
const COLOR_LOCKED : Color = GameColorUtil.COLOR_BAD_READABLE

@export_group("Info")
@export var key : String
@export var label : String
@export_multiline var description : String
@export var icon : Texture2D

@export_group("Learning")
@export var base_cost : float = 1
@export var prerequisites : Array[Knowledge] = []

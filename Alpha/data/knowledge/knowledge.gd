@icon("res://assets/textures/head/idea.svg")
class_name Knowledge
extends Resource


@export_group("Info")
@export var key : String
@export var label : String
@export_multiline var description : String
@export var icon : Texture2D

@export_group("Learning")
@export var base_cost : float = 1
@export var prerequisites : Array[Knowledge] = []

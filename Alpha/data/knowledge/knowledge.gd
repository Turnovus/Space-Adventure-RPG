@icon("res://assets/anatomy/brain.svg")
extends Resource
class_name Knowledge


@export_group("Info")
@export var key : String
@export var label : String
@export_multiline var description : String
@export var icon : Texture2D

@export_group("Learning")
@export var base_cost : float = 1
@export var prerequisites : Array[Knowledge] = []

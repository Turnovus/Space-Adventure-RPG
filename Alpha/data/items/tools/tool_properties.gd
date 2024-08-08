@icon("res://assets/textures/object/hammer-drop.svg")
class_name ToolProperties
extends Resource
## Simple class used to wrap up tool-related information for an [ItemTemplate].
##
## An [ItemTemplate] can use one or more of these to define which [ToolTemplate] capabilities it
## provides, and how effectively it provides those abilities. The actual capacities of the finished
## [Item] may be affected by other factors in-game.


@export var tool : ToolTemplate
@export var effectiveness : float

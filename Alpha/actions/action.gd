class_name Action
extends Resource


@export var base_label : String
@export var icon : Texture2D


func create_doer(issuer : Entity) -> ActionDoer:
	return ActionDoer.new(self, issuer)

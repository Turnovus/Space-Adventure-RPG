class_name ActionDoer
extends Node


var action : Action
var issuer : Entity


func _init(new_action : Action, new_issuer : Entity):
	action = new_action
	issuer = new_issuer

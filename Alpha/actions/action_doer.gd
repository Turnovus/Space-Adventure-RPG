class_name ActionDoer
extends Node


var action : Action
var issuer : Entity
var agent : Agent


func _init(new_action : Action, new_issuer : Entity, new_agent : Agent):
	action = new_action
	issuer = new_issuer
	agent = new_agent

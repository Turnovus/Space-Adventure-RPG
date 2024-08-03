extends HBoxContainer


var component : ActionComponentPotencySkill
var agent : Agent

@onready var icon = $TextureRect
@onready var label = $Label


func _ready():
	var galaxy : Galaxy = await ReferenceSingleton.get_galaxy()
	galaxy.turn_post.connect(_on_turn_post)


func set_component(new_component : ActionComponent, new_agent : Agent):
	component = new_component as ActionComponentPotencySkill
	agent = new_agent
	update_readout()


func _on_turn_post(_turn : int):
	update_readout()


func update_readout():
	var skill : Skill = component.skill
	if skill.icon != null:
		icon.texture = skill.icon
	var potency = component.affect_potency(1, agent)
	potency = snapped(potency, 0.01)
	label.text = "x" + str(potency)
	tooltip_text = skill.label

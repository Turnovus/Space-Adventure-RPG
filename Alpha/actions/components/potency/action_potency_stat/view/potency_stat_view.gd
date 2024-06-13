extends HBoxContainer


var stat_component : ActionComponentPotencyStat
var agent : Agent

@onready var icon = $TextureRect
@onready var label = $Label


func _ready():
	var galaxy : Galaxy = get_tree().root.get_child(0).get_galaxy()
	galaxy.turn_post.connect(_on_turn_post)


func set_component(component : ActionComponent, new_agent : Agent):
	stat_component = component as ActionComponentPotencyStat
	agent = new_agent
	update_readout()


func _on_turn_post(_turn : int):
	update_readout()


func update_readout():
	var stat : Stat = stat_component.stat
	if stat.icon != null:
		icon.texture = stat.icon
	label.text = "x" + str(stat_component.affect_potency(1, agent))
	tooltip_text = stat.label

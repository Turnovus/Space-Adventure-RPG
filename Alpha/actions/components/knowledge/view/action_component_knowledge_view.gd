extends Label


const TEXT_COLOR : Color = Color.INDIAN_RED

var component : ActionComponentKnowledge
var agent : Agent


func _ready():
	var galaxy : Galaxy = get_tree().root.get_child(0).get_galaxy()
	galaxy.turn_post.connect(_on_turn_post)
	set("theme_override_colors/font_color", TEXT_COLOR)


func set_component(new_component : ActionComponent, new_agent : Agent):
	component = new_component as ActionComponentKnowledge
	agent = new_agent
	text = "Missing knowledge: " + component.required_knowledge.label
	update_readout()


func _on_turn_post(_turn : int):
	update_readout()


func update_readout():
	visible = not agent.knowledge.has_learned(component.required_knowledge)

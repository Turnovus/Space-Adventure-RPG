extends Label


const TEXT_COLOR : Color = Color.INDIAN_RED

var component : ActionComponentTagger
var agent : Agent


func _ready():
	var galaxy : Galaxy = get_tree().root.get_child(0).get_galaxy()
	galaxy.turn_post.connect(_on_turn_post)
	set("theme_override_colors/font_color", TEXT_COLOR)


func set_component(new_component : ActionComponent, new_agent : Agent):
	component = new_component as ActionComponentTagger
	agent = new_agent
	agent.actions.actions_changed.connect(_on_actions_changed)
	update_readout()


func _on_turn_post(_turn : int):
	update_readout()


func _on_actions_changed():
	update_readout()


func update_readout():
	visible = not component.action_possible(agent)
	
	match component.mode:
		ActionComponentTagger.ActionTagType.BLOCK:
			if component.push_tag:
				text = "Already " + component.tag
			else:
				text = "Not possible while " + component.tag
		ActionComponentTagger.ActionTagType.REQUIRE:
			text = "Must be " + component.tag

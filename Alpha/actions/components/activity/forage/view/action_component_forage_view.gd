extends Label


const TEXT_COLOR : Color = Color.INDIAN_RED

var component : ActionComponentForage
var agent : Agent


func _ready():
	var galaxy : Galaxy = await ReferenceSingleton.get_galaxy()
	galaxy.turn_post.connect(_on_turn_post)
	set("theme_override_colors/font_color", TEXT_COLOR)


func set_component(new_component : ActionComponent, new_agent : Agent):
	component = new_component as ActionComponentForage
	agent = new_agent
	update_readout()


func _on_turn_post(_turn : int):
	update_readout()


func update_readout():
	var biome : Biome = component.get_agent_biome(agent)
	var can_forage : bool = component.can_forage(biome)
	if can_forage:
		visible = false
		return
	
	visible = true
	if biome == null:
		text = "Foraging is not possible here"
		return
	
	text = "No {forage} in biome: {biome}".format({
		"forage" : component.forage_group.label,
		"biome" : biome.label.capitalize(),
	})

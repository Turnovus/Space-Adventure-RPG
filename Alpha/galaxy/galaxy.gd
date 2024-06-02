extends Node
class_name Galaxy


const BASE_ENTITY = preload("res://galaxy/entities/entity.gd")
const PLANET_ENTITY = preload("res://galaxy/entities/celestial/planet.gd")
const AGENT_ENTITY = preload("res://galaxy/entities/misc/agent.gd")

var turn : int = 0
var player : Agent


# Signals sent during execution of a turn
signal turn_start
signal turn_end
signal turn_post


func _ready():
	generate_galaxy()
	make_player()


func generate_galaxy():
	for i in range(0,10):
		# TODO: We're just using base entities as suns here because we don't need them to do
		# anything special right now.
		var sun = BASE_ENTITY.new()
		sun.name = "Sun " + str(i)
		
		for j in range(0,4):
			var planet = PLANET_ENTITY.new()
			planet.name = "Planet " + str(i) + "." + str(j)
			sun.add_child(planet)
			
		add_child(sun)


func make_player():
	player = AGENT_ENTITY.new()
	player.is_player = true
	var start_sun = get_child(randi_range(0, get_child_count() - 1))
	var start_planet = start_sun.get_child(randi_range(0, start_sun.get_child_count() - 1))
	start_planet.add_child(player)


func request_turn_advance():
	# Logic to dictate if a turn is possible goes here, before turn execution
	# begins.
	do_turn()


func do_turn():
	_start_turn()
	
	_update_entities()
	
	_end_turn()
	_post_turn()


func _update_entities():
	for child in get_children():
		pass


func _start_turn():
	emit_signal("turn_start", turn)


func _end_turn():
	emit_signal("turn_end", turn)
	turn += 1


func _post_turn():
	emit_signal("turn_post", turn)

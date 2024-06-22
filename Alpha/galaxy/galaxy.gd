extends Node
class_name Galaxy


# Signals sent during execution of a turn
signal turn_start(turn: int)
signal turn_end(turn: int)
signal turn_post(turn: int)
# Signals sent in response to player action
signal player_actions_changed
signal player_points_reallocated

const BASE_ENTITY = preload("res://galaxy/entities/entity.gd")
const SUN_ENTITY = preload("res://galaxy/entities/celestial/sun/sun.tscn")
const PLANET_ENTITY = preload("res://galaxy/entities/celestial/planet/planet.tscn")
const AGENT_ENTITY = preload("res://galaxy/entities/misc/agent/agent.tscn")
const SITE_ENTITY = preload("res://galaxy/entities/celestial/planet/site/site.tscn")

var turn : int = 0
var player : Agent


func _ready():
	generate_galaxy()
	make_player()


func generate_galaxy():
	for i in range(0,10):
		var sun = SUN_ENTITY.instantiate()
		sun.name = "Sun " + str(i)
		
		for j in range(0,4):
			var planet = PLANET_ENTITY.instantiate()
			planet.name = "Planet " + str(i) + "." + str(j)
			sun.add_child_entity(planet)
			
			for k in range(0, 20):
				var site = SITE_ENTITY.instantiate()
				site.setup(planet.get_random_location())
				planet.add_child_entity(site)
			
		add_child(sun)


func make_player():
	player = AGENT_ENTITY.instantiate()
	player.is_player = true
	var start_sun = get_child(randi_range(0, get_child_count() - 1))
	var planets : Array[Planet] = []
	for i in start_sun.get_children():
		if i is Planet:
			planets.append(i)
	var start_planet = planets[randi_range(0, len(planets) - 1)]
	start_planet.add_child_entity(player)


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
		var entity : Entity = child as Entity
		if entity == null:
			continue
		
		entity.do_turn(turn)


func _start_turn():
	emit_signal("turn_start", turn)


func _end_turn():
	emit_signal("turn_end", turn)
	turn += 1


func _post_turn():
	emit_signal("turn_post", turn)

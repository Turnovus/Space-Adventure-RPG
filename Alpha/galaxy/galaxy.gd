extends Node
class_name Galaxy


const BASE_ENTITY = preload("res://galaxy/entities/entity.gd")
const PLANET_ENTITY = preload("res://galaxy/entities/celestial/planet.tscn")
const AGENT_ENTITY = preload("res://galaxy/entities/misc/agent/agent.tscn")

var turn : int = 0
var player : Agent


# Signals sent during execution of a turn
signal turn_start(turn: int)
signal turn_end(turn: int)
signal turn_post(turn: int)
# Signals sent in response to player action
signal player_actions_changed


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
			var planet = PLANET_ENTITY.instantiate()
			planet.name = "Planet " + str(i) + "." + str(j)
			sun.add_child_entity(planet)
			
		add_child(sun)


func make_player():
	player = AGENT_ENTITY.instantiate()
	player.is_player = true
	var start_sun = get_child(randi_range(0, get_child_count() - 1))
	var start_planet = start_sun.get_child(randi_range(0, start_sun.get_child_count() - 1))
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


func try_add_player_action(action : Action):
	player.actions_this_turn.append(action)
	player_actions_changed.emit()


func try_remove_player_action(action : Action):
	player.actions_this_turn.erase(action)
	player_actions_changed.emit()


func _update_entities():
	for child in get_children():
		var entity : Entity = child as Entity
		if entity == null:
			continue
		
		entity.do_turn()


func _start_turn():
	emit_signal("turn_start", turn)


func _end_turn():
	emit_signal("turn_end", turn)
	turn += 1


func _post_turn():
	emit_signal("turn_post", turn)

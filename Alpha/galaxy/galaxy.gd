extends Node
class_name Galaxy


var turn : int = 0


# Signals sent during execution of a turn
signal turn_start
signal turn_end
signal turn_post


func _ready():
	pass


func request_turn_advance():
	# Logic to dictate if a turn is possible goes here, before turn execution
	# begins.
	do_turn()


func do_turn():
	_start_turn()
	_end_turn()
	_post_turn()


func _start_turn():
	emit_signal("turn_start", turn)


func _end_turn():
	emit_signal("turn_end", turn)
	turn += 1


func _post_turn():
	emit_signal("turn_post", turn)

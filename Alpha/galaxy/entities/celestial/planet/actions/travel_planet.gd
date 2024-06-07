extends Action


func action_turn(agent : Agent):
	agent.move_relative(Vector2(0,0.005))

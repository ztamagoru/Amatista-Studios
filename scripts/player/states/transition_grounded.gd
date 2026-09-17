extends StateTransition


func can_transition() -> bool:
	var player := root as Player
	
	return player.is_on_floor()

extends StateTransition

func can_transition() -> bool:
	var player := root as Player
	
	return player.input.is_aiming()

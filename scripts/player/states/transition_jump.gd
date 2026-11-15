extends StateTransition

func can_transition() -> bool:
	var player := root as Player
	
	return player.skills["jump"] and player.input.is_jumping

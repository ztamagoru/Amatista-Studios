extends StateTransition

func can_transition() -> bool:
	var player := root as Player
	
	return player.skills["slingshot"] && player.input.is_aiming()

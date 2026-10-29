extends StateTransition

func can_transition() -> bool:
	var player := root as Player
	
	return player.slingshot_collected && player.input.is_aiming()

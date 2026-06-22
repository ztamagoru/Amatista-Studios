@tool
extends NPC

# --

var congratulated_for_puzzle : bool = true

# --

func has_earing():
	return quest.are_subquests_completed()

func give_notebook(): # acá le tendría que dar el cuaderno al jugador
	quest.are_subquests_completed()
	pass

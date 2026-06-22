@tool

extends NPC

# --

var congratulated_for_puzzle : bool = true

# --

func check_started():
	return quest_holder.quest

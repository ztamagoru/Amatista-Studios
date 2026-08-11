@tool

extends NPC

# --

var _tutorial_completed : bool = false 

# --

func check_one_cured():
	for tree in Globals.current_trees:
		if tree._is_cured:
			return true
	return false

func check_all_cured():
	for tree in Globals.current_trees:
		if tree._is_cured == false:
			return false
	return true

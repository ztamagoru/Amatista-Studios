extends NPC

# --

var _tutorial_completed : bool = false 

# --

func check_one_cured() -> bool:
	for tree in Globals.current_trees:
		if tree._is_cured:
			return true
	return false

func check_all_cured() -> bool:
	for tree in Globals.current_trees:
		if tree._is_cured == false:
			return false
	return true

extends NPC

# --

var _tutorial_completed : bool = false 

var sick_trees : Array[Sick_Environment] = []
const sick_amount : int = 20

# --

func _ready():
	add_to_group("interactable")
	
	connect_signals()
	outline()
	if gives_quest: quest_initiation()
	
	# --------
	
	await get_tree().process_frame
	
	set_up_trees()

func set_up_trees():
	var available_trees : Array[Sick_Environment] = []
	
	for tree in get_tree().get_nodes_in_group("sick_environment"):
		if tree is Sick_Environment:
			available_trees.append(tree)
	
	for i in sick_amount:
		if available_trees.is_empty():
			continue
		
		var tree : Sick_Environment = available_trees.pick_random()
		available_trees.erase(tree)
		
		Globals.sick_trees.append(tree)
		tree.set_sick()
	
	for tree in available_trees:
		tree.set_healthy()

func check_one_cured() -> bool:
	for tree in Globals.sick_trees:
		if tree._is_cured:
			return true
	return false

func check_all_cured() -> bool:
	for tree in Globals.sick_trees:
		if tree._is_cured == false:
			return false
	return true

func sick_trees_left() -> String:
	var trees_left : int
	
	for tree in Globals.sick_trees:
		if not tree._is_cured: trees_left += 1
	
	return str(trees_left)

@tool

extends Item

# --

@export_category("Pumpkin puzzle")
@export var player : CharacterBody3D
@export var quest_giver : NPC

# --

func start_puzzle():
	if puzzle_scene.is_empty(): return
	
	var scene = load(puzzle_scene).instantiate()
	
	if not puzzle_subviewport: return
	
	if scene.has_signal("puzzle_won"): scene.puzzle_won.connect(puzzle_won)
	if scene.has_signal("puzzle_exited"): scene.puzzle_won.connect(puzzle_exited)
	
	puzzle_subviewport.add_child(scene)
	puzzle_layer.visible = true
	player.process_mode = Node.PROCESS_MODE_DISABLED

func check_quest_completed():
	return quest_giver.quest.is_completed()

func check_quest_started():
	return quest_giver.quest.is_accepted()

func puzzle_won():
	puzzle_layer.visible = false
	quest_giver.quest.set_completed()
	DialogueManager.show_dialogue_balloon(dialogue, "puzzle_completed", [self])

func puzzle_exited():
	puzzle_layer.visible = false
	DialogueManager.show_dialogue_balloon(dialogue, "teasing", [self])

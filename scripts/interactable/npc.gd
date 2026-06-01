extends Interactable
class_name NPC

# --

@export_group("Puzzle", "puzzle_")
@export_file_path("*.tscn") var puzzle_scene : String
var puzzle_completed : bool = false

var first_time_dialog : bool = true

#--

func _process(_delta: float) -> void:
	if _is_interactable and Input.is_action_just_pressed("interact") and _can_start_dialog:
		if dialogue_route:
			DialogueManager.show_dialogue_balloon(dialogue_route, "start", [self])

func start_puzzle():
	get_tree().change_scene_to_file(puzzle_scene)

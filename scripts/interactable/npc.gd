@tool

extends Interactable
class_name NPC

# --

@export_group("Puzzle")
@export_custom(PROPERTY_HINT_GROUP_ENABLE, "") var has_puzzle : bool = false
@export_file_path("*.tscn") var puzzle_scene : String
@export var puzzle_completed : bool = false
@export var puzzle_sub_viewport : SubViewport
@export var puzzle_layer : CanvasLayer

#--


func _process(_delta: float) -> void:

	
	if _is_interactable and Input.is_action_just_pressed("interact") and _can_start_dialog:
		if dialogue_route:
			DialogueManager.show_dialogue_balloon(dialogue_route, "start", [self])

func start_puzzle():
	pass

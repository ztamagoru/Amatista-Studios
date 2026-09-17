extends Interactable
class_name PuzzleTrigger

# --

@export_file_path("*.tscn") var puzzle_scene : String
@export var puzzle_layer : CanvasLayer
@export var puzzle_subviewport : SubViewport

# --

var is_completed : bool = false

# --

func start_puzzle() -> void:
	pass

func complete_puzzle() -> void:
	pass

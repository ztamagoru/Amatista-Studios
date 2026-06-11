@tool

extends Interactable
class_name Item

# --

@export_group("Puzzle")
@export_custom(PROPERTY_HINT_GROUP_ENABLE, "") var has_puzzle : bool = false
@export_file_path("*.tscn") var puzzle_scene : String
@export var puzzle_completed : bool
@export var puzzle_layer : CanvasLayer
@export var puzzle_subviewport : SubViewport

@export_group("Pickable")
@export_custom(PROPERTY_HINT_GROUP_ENABLE, "") var is_pickable : bool = false
@export var item_id : String
@export var item_name : String
@export var item_quantity : int

# --

func _physics_process(_delta: float) -> void:
	if _is_interacting and Input.is_action_just_pressed("interact"):
		if is_pickable: pick_up_item()

func start_puzzle():
	pass

func pick_up_item():
	# lógica para agregar el item al inventario
	
	DialogueManager.show_dialogue_balloon(dialogue, "start", [self])
	
	queue_free()

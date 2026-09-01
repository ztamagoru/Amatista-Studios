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

# --

@export_group("Pickable")
@export_custom(PROPERTY_HINT_GROUP_ENABLE, "") var is_pickable : bool = false
@export var item_data : ItemData 
@export var item_quantity : int = 1

var pickup_dialogue : DialogueResource = load("res://dialogs/item_grabbed.dialogue")

# --

func _physics_process(_delta: float) -> void:
	if _is_interacting and Input.is_action_just_pressed("interact"):
		if is_pickable: pick_up_item()

func start_puzzle():
	pass

func pick_up_item():
	InventoryManager.add_item(
		item_data.id,
		item_quantity
	)
	DialogueManager.show_dialogue_balloon(pickup_dialogue, "start", [self])
	queue_free()

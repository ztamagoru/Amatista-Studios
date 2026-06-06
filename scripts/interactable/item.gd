extends Interactable
class_name Item

# --

@export_group("Item Values", "item_")
@export var item_id : String
@export var item_name : String
@export var item_quantity : int

# --

func _physics_process(_delta: float) -> void:
	if _is_interactable and Input.is_action_just_pressed("interact"):
		pick_up_item()

func pick_up_item():
	# lógica para agregar el item al inventario
	
	DialogueManager.show_dialogue_balloon(dialogue_route, "start", [self])
	
	queue_free()

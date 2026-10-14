extends Interactable
class_name Item

# --

@export var item : ItemResource
@export var item_quantity : int = 1

# --

func _ready() -> void:
	tree_exiting.connect(exiting_tree)

func exiting_tree():
	pass

func pick_up() -> void:
	pass

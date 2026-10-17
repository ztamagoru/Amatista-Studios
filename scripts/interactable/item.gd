extends Interactable
class_name Item

# --

@export_group("Quest Info")
@export var quest_id : StringName

@export_group("Item Info")
@export var item : ItemResource
@export var item_quantity : int = 1

# --

var should_initialize : bool = true

# --

func _ready() -> void:
	if _should_be_removed():
		should_initialize = false
		queue_free()
		return
	
	tree_exiting.connect(_exiting_tree)
	super._ready()

func _should_be_removed() -> bool:
	if quest_id.is_empty(): return false
	
	if QuestManager.is_completed(quest_id): return true
	
	return false

func _exiting_tree():
	pass

func pick_up() -> void:
	AudioManager.on_pick_item()

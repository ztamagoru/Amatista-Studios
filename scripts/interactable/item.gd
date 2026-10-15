extends Interactable
class_name Item

# --

@export_group("Quest Info")
@export var quest_id : StringName

@export_group("Item Info")
@export var item : ItemResource
@export var item_quantity : int = 1

@export_group("Diary Entry", "diary_")
@export var diary_entry_id : StringName

# --

var should_initialize : bool = true

# --

func _ready() -> void:
	if _should_be_removed():
		should_initialize = false
		queue_free()
		return
	
	tree_exiting.connect(_exiting_tree)
	
	QuestManager.quest_state_changed.connect(_on_quest_state_changed)
	_update_quest_state()
	
	super._ready()

func _should_be_removed() -> bool:
	return not quest_id.is_empty() and QuestManager.is_completed(quest_id)

func _exiting_tree():
	pass

func pick_up() -> void:
	if item == null: return
	
	_execute_dialogue(self)
	
	if not diary_entry_id.is_empty():
		DiaryEntriesManager.unlock_entry(diary_entry_id)
	
	QuestManager.report_item_collected(item.id, item_quantity)
	InventoryManager.add_items(item, item_quantity)
	queue_free()

func _on_quest_state_changed(changed_quest_id : StringName) -> void:
	if changed_quest_id != quest_id: return
	_update_quest_state()

func _update_quest_state() -> void:
	if quest_id.is_empty():
		can_interact = true
		return
	
	can_interact = (
		QuestManager.is_accepted(quest_id)
		and not QuestManager.is_completed(quest_id)
	)

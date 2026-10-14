extends Item

# --

@export var quest_id : StringName

# --

func _ready() -> void:
	if QuestManager.is_completed(quest_id):
		queue_free()
		return
	
	QuestManager.quest_state_changed.connect(_on_quest_state_changed)
	_update_quest_state()

func _on_quest_state_changed(changed_quest_id : StringName) -> void:
	if changed_quest_id != quest_id: return
	_update_quest_state()

func _update_quest_state() -> void:
	can_interact = (
		QuestManager.is_accepted(quest_id)
		and not QuestManager.is_completed(quest_id)
	)

extends NPC
class_name NPCQuest

# --

@export_group("Quest")
@export var quest_id : StringName

# --

func _get_quest() -> QuestResource:
	if QuestManager.database == null: return null
	return QuestManager.database.get_quest(quest_id)

func give_quest() -> bool:
	if _get_quest() == null: return false
	return QuestManager.accept_quest(quest_id)

func is_quest_accepted() -> bool:
	if _get_quest() == null: return false
	return QuestManager.is_accepted(quest_id)

func is_quest_completed() -> bool:
	if _get_quest() == null: return false
	return QuestManager.is_completed(quest_id)

func get_active_subquest() -> QuestResource:
	if _get_quest() == null: return null
	return QuestManager.get_active_subquest(quest_id)

func get_active_subquests() -> Array[QuestResource]:
	if _get_quest() == null: return []
	return QuestManager.get_active_subquests(quest_id)

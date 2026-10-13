extends Resource
class_name QuestDatabase

# --

@export var quests : Array[QuestResource] = []

var _quests_by_id : Dictionary[StringName, QuestResource] = {}

func build_index() -> void:
	_quests_by_id.clear()
	
	for quest in quests:
		_register_recursive(quest)

func _register_recursive(quest : QuestResource) -> void:
	if quest == null: return
	
	if quest.id == &"":
		push_warning("QuestDatabase: Mission without an ID.")
		return
	
	if _quests_by_id.has(quest.id):
		push_warning("QuestDatabase: Duplicate quest ID: " + str(quest.id))
		return
	
	_quests_by_id[quest.id] = quest
	
	for subquest in quest.subquests:
		_register_recursive(subquest)

func get_quest(id : StringName) -> QuestResource:
	return _quests_by_id.get(id)

func has_quest(id : StringName) -> bool:
	return _quests_by_id.has(id)

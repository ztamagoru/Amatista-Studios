@tool
extends NPC
class_name NPCQuest

# --

@export_group("Quest")
@export var quest_id : StringName
@export var can_offer_quest : bool 

@export_group("Event")
@export var event_id : StringName

@export_group("Quest Objectives")
@export var puzzle_objective_id : StringName
@export_subgroup("Deliveries", "deliver_")
@export var deliver_objective_id : StringName:
	set(value):
		deliver_objective_id = value
		notify_property_list_changed()
@export var deliver_dialogue_title : String

# --

func _get_quest() -> QuestResource:
	if QuestManager.database == null: return null
	return QuestManager.database.get_quest(quest_id)

func give_quest() -> bool:
	if _get_quest() == null: return false
	return QuestManager.accept_quest(quest_id)

# --

func is_quest_accepted() -> bool:
	if _get_quest() == null: return false
	return QuestManager.is_accepted(quest_id)

func is_quest_completed() -> bool:
	if _get_quest() == null: return false
	return QuestManager.is_completed(quest_id)

func is_objective_completed(objective_id : StringName) -> bool:
	var quest := _get_quest()
	if quest == null: return false
	
	for objective in quest.objectives:
		if objective == null or objective.id != objective_id: continue
		return QuestManager.get_objective_progress(quest_id, objective_id) >= objective.required_amount
	
	return false

# --

func get_active_subquest() -> QuestResource:
	if _get_quest() == null: return null
	return QuestManager.get_active_subquest(quest_id)

func get_active_subquests() -> Array[QuestResource]:
	if _get_quest() == null: return []
	return QuestManager.get_active_subquests(quest_id)

# --

func interact() -> void:
	if deliver_objective_id.is_empty():
		super.interact()
		return
	
	if is_quest_accepted() and not is_quest_completed():
		if deliver_quest_item(deliver_objective_id):
			if dialogue_handler.dialogue != null and not deliver_dialogue_title.is_empty():
				DialogueManager.show_dialogue_balloon(
					dialogue_handler.dialogue,
					deliver_dialogue_title,
					[self, dialogue_handler]
				)
				return
			return
	
	super.interact()

func report_event() -> void:
	if event_id == null: return
	if _get_quest() == null: return
	QuestManager.report_event(event_id)

func deliver_quest_item(objective_id: StringName) -> bool:
	if QuestManager.deliver_item(quest_id, objective_id):
		return true
	
	for subquest in get_active_subquests():
		if QuestManager.deliver_item(subquest.id, objective_id): return true
	
	return false

# --

func _validate_property(property: Dictionary) -> void:
	if property.name == "deliver_dialogue_title":
		if deliver_objective_id.is_empty():
			property.usage &= ~PROPERTY_USAGE_EDITOR

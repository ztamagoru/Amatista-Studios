extends NPC
class_name NPCQuest

# --

var quest_manager : QuestManager 
var quest

# -- 

@export_group("Quest")
@export var quest_name : StringName
@export_multiline() var quest_description : String

@export_subgroup("Subquest")
@export_custom(PROPERTY_HINT_GROUP_ENABLE, "") var is_subquest : bool = false
@export var quest_holder : NPCQuest

# --

func quest_initiation() -> void:
	quest_manager = QuestManager.new()
	quest = quest_holder.quest.add_subquest(
		quest_name,
		quest_description
	) if is_subquest else quest_manager.add_quest(
		quest_name,
		quest_description
	)

# --

func give_quest() -> void:
	quest.set_accepted()

func is_quest_accepted() -> bool:
	return quest.is_active()

# --

func complete_quest() -> void:
	quest.set_completed()

func is_quest_completed() -> bool:
	return quest.is_completed()

# --

func check_quest_parent_completed() -> bool:
	return quest_holder.quest.is_completed()

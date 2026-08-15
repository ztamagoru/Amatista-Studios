@icon("res://assets/icons/npc.svg")
@tool

extends Interactable
class_name NPC

# --

@export_group("Quests")
var quest_manager: QuestManager = QuestManager.new()
var quest : QuestEntry

@export_group("Gives quest")
@export_custom(PROPERTY_HINT_GROUP_ENABLE, "") var gives_quest : bool = false
@export var quest_name : String = ""
@export_multiline() var quest_description : String = ""

@export_subgroup("Is a subquest")
@export_custom(PROPERTY_HINT_GROUP_ENABLE, "") var is_subquest : bool = false
@export var quest_holder : NPC

# --

func quest_initiation():
	quest = quest_holder.quest.add_subquest(
		quest_name,
		quest_description
	) if is_subquest else quest_manager.add_quest(
		quest_name,
		quest_description
	)

func give_quest():
	quest.set_accepted()

func is_quest_accepted():
	return quest.is_active()

func complete_quest():
	quest.set_completed()

func is_quest_completed():
	return quest.is_completed()

func check_quest_parent_completed():
	return quest_holder.quest.is_completed()

# --

func start_puzzle():
	pass

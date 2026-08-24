@tool

extends NPC

# --

@export_category("Subquests")
@export var flower_subquest : Dictionary[String, String]

var subquests : Array[QuestEntry] = []

var current_subquest : QuestEntry

# --

func _ready():
	add_to_group("interactable")
	connect_signals()
	outline()
	quest_initiation()
	
	# --
	
	for i in flower_subquest:
		var new_quest : QuestEntry = quest.add_subquest(
			i,
			flower_subquest[i]
		)
		
		subquests.append(new_quest)

func get_uncompleted_quest() -> QuestEntry:
	var available_quests : Array[QuestEntry] = []
	
	for subquest in subquests:
		if subquest == current_subquest:
			continue
		
		if subquest.is_completed():
			continue
		
		available_quests.append(subquest)
	
	if available_quests.is_empty():
		return null
	return available_quests.pick_random()

func give_next_quest():
	var next_quest : QuestEntry = get_uncompleted_quest()
	
	if next_quest == null:
		return
	
	current_subquest = next_quest

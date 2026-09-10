extends NPC

# --

signal flower_now_needed(flower_id : String)

# --

@export_category("Subquests")
@export var flower_subquest : Dictionary[String, String]
@export var flower_hints : Dictionary[String, String]

var subquests : Array[QuestEntry] = []
var subquests_ids : Dictionary[QuestEntry, String] = {}

var current_subquest : QuestEntry

# --

func _ready():
	add_to_group("interactable")
	connect_signals()
	outline()
	quest_initiation()
	
	# --
	
	for id in flower_subquest:
		var new_quest : QuestEntry = quest.add_subquest(
			id,
			flower_subquest[id]
		)
		
		subquests.append(new_quest)
		subquests_ids[new_quest] = id

# -------------------------------------------

func get_uncompleted_quest() -> QuestEntry:
	var available_quests : Array[QuestEntry] = []
	
	for subquest in subquests:
		if subquest.is_completed():
			continue
		
		available_quests.append(subquest)
	
	if available_quests.is_empty():
		return null
	
	return available_quests.pick_random()

func give_next_quest():
	current_subquest = get_uncompleted_quest()
	
	if not current_subquest == null: emit_signal("flower_now_needed", get_current_flower_id())

func is_quest_accepted() -> bool:
	return current_subquest != null

func is_quest_available() -> bool:
	if current_subquest == null:
		return false
	
	return current_subquest.is_completed()

# -------------------------------------------

func get_current_flower_id() -> String:
	if current_subquest == null:
		return ""
	
	return subquests_ids.get(current_subquest, "")

func has_flower() -> bool:
	if current_subquest == null:
		return false
	
	var flower_id := get_current_flower_id()
	
	return InventoryManager.has_item(flower_id)

func complete_subquest() -> void:
	if current_subquest == null:
		return
	
	if not has_flower():
		return
	
	var flower_id := get_current_flower_id()
	InventoryManager.remove_item(flower_id)
	current_subquest.set_completed()
	current_subquest = null

# -------------------------------------------

func are_all_quests_completed() -> bool:
	for subquest in subquests: 
		if not subquest.is_completed(): return false
	
	return true

func get_current_flower_hint() -> String:
	if current_subquest == null:
		return ""
	
	var flower_id := get_current_flower_id()
	return flower_hints.get(flower_id, "")

# -------------------------------------------

func is_flower_needed(flower_id : String) -> bool:
	if current_subquest == null:
		return false
	return get_current_flower_id() == flower_id

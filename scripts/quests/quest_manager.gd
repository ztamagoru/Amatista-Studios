extends Node

# --

signal quest_accepted(quest_id : StringName)
signal quest_completed(quest_id : StringName)
signal quest_state_changed(quest_id : StringName)
signal objective_progress_changed(
	quest_id : StringName,
	objective_id : StringName,
	progress : int,
	required : int
)

# --

const DATABASE_PATH : String = "res://resources/quests/quest_database.tres"

var database : QuestDatabase
var _states : Dictionary[StringName, Dictionary] = {}

func _ready() -> void:
	database = load(DATABASE_PATH) as QuestDatabase
	
	if database == null:
		push_error("QuestManager: Couldn't load quest database.")
		return
	
	database.build_index()

func has_quest(quest_id : StringName) -> bool:
	return database != null and database.has_quest(quest_id)

func is_accepted(quest_id : StringName) -> bool:
	return _states.get(quest_id, {}).get("accepted", false)

func is_completed(quest_id : StringName) -> bool:
	return _states.get(quest_id, {}).get("completed", false)

func accept_quest(quest_id : StringName) -> bool:
	if not has_quest(quest_id):
		push_warning("QuestManager: Unknown quest: " + str(quest_id))
		return false
	
	if is_accepted(quest_id): return false
	
	var state : Dictionary = _get_or_create_state(quest_id)
	state["accepted"] = true
	
	quest_accepted.emit(quest_id)
	quest_state_changed.emit(quest_id)
	
	_check_completition(quest_id)
	_save_progress()
	return true

func _get_or_create_state(quest_id : StringName) -> Dictionary:
	if not _states.has(quest_id):
		var quest : QuestResource = database.get_quest(quest_id)
		var objectives : Dictionary[StringName, int] = {}
		
		for objective in quest.objectives:
			if objective == null: continue
			objectives[objective.id] = 0
		
		_states[quest_id] = {
			"accepted": false,
			"completed": false,
			"objectives": objectives
		}
	
	return _states[quest_id]

func get_objective_progress(quest_id : StringName, objective_id : StringName) -> int:
	var state : Dictionary = _states.get(quest_id, {})
	var objectives : Dictionary = state.get("objectives", {})
	return int(objectives.get(objective_id, 0))

func report_event(event_id : StringName, amount : int = 1) -> void:
	if amount <= 0: return
	_report_progress(QuestObjective.ObjectiveType.EVENT, event_id, amount)

func report_item_collected(item_id : StringName, amount : int = 1) -> void:
	if amount <= 0: return
	_report_progress(QuestObjective.ObjectiveType.COLLECT_ITEM, item_id, amount)

func _report_progress(objective_type : int, target_id : StringName, amount : int) -> void:
	var changed : bool = false
	var quest_ids : Array = _states.keys()
	
	for quest_id in quest_ids:
		if not is_accepted(quest_id) or is_completed(quest_id): continue
		
		var quest: QuestResource = database.get_quest(quest_id)
		if quest == null: continue
		
		var state : Dictionary = _states[quest_id]
		var objectives : Dictionary = state["objectives"]
		
		for objective in quest.objectives:
			if objective == null: continue
			if not objective.type == objective_type: continue
			
			var matches : bool = false
			
			if objective_type == QuestObjective.ObjectiveType.EVENT:
				matches = objective.event_id == target_id
			else:
				matches = objective.item_id == target_id
			
			if not matches: continue
			
			var current : int = int(objectives.get(objective.id, 0))
			var next : int = mini(current + amount, objective.required_amout)
			
			if next == current: continue
			
			objectives[objective.id] = next
			changed = true
			
			objective_progress_changed.emit(
				quest_id,
				objective.id,
				next,
				objective.required_amout
			)
		
		if _check_completition(quest_id): changed = true
	
	if changed: _save_progress()

func _check_completition(quest_id : StringName) -> bool:
	if is_completed(quest_id) or not is_accepted(quest_id): return false
	
	var quest : QuestResource = database.get_quest(quest_id)
	if quest == null: return false
	
	var state : Dictionary = _states[quest_id]
	var objectives: Dictionary = state["objectives"]
	
	for objective in quest.objectives:
		if objective == null: continue
		if int(objectives.get(objective.id, 0)) < objective.required_amount: return false
	
	state["completed"] = true
	
	quest_completed.emit(quest_id)
	quest_state_changed.emit(quest_id)
	
	var parent : QuestResource = _find_parent(quest_id, database.quests)
	if not parent == null: _check_completition(parent.id)
	
	return true

func _find_parent(target_id : StringName, candidates : Array[QuestResource]) -> QuestResource:
	for candidate in candidates:
		if candidate == null: continue
		
		for child in candidate.subquests:
			if child != null and child.id == target_id: return candidate
		
		var parent : QuestResource = _find_parent(target_id, candidate.subquests)
		if not parent == null: return parent
	
	return null 

func deliver_item(quest_id : StringName, objective_id : StringName) -> bool:
	if not is_accepted(quest_id) or is_completed(quest_id): return false
	
	var quest : QuestResource = database.get_quest(quest_id)
	if quest == null: return false
	
	var objective : QuestObjective
	
	for candidate in quest.objectives:
		if candidate != null and candidate.id == objective_id:
			objective = candidate
			break
	
	if objective == null: return false
	if objective.type != QuestObjective.ObjectiveType.DELIVER_ITEM: return false
	
	var current := get_objective_progress(quest_id, objective_id)
	var remaining : int = objective.required_amount
	
	if remaining <= 0: return false
	
	var item : ItemResource = ItemDatabase.get_item(objective.item_id)
	if item == null: 
		push_warning("QuestManager: Unknown item: " + str(objective.item_id))
		return false
	
	var amount_to_deliver : int = mini(remaining, InventoryManager.get_amount(item))
	if amount_to_deliver <= 0: return false
	if not InventoryManager.remove_item(item, amount_to_deliver): return false
	
	var state : Dictionary = _states[quest_id]
	var objectives : Dictionary = state["objectives"]
	var next : int = current + amount_to_deliver
	objectives[objective_id] = next
	
	objective_progress_changed.emit(quest_id, objective_id, next, objective.required_amount)
	_check_completition(quest_id)
	_save_progress()
	return true

func get_save_data() -> Dictionary:
	var saved_states : Dictionary = {}
	
	for quest_id in _states:
		saved_states[String(quest_id)] = _states[quest_id].duplicate(true)
	
	return { "states": saved_states }

func load_save_data(data : Dictionary) -> void:
	_states.clear()
	
	var saved_states = data.get("states", {})
	if not saved_states is Dictionary: return
	
	for raw_id in saved_states:
		var quest_id : StringName = StringName(str(raw_id))
		
		if not has_quest(quest_id):
			push_warning("QuestManager: Unknown quest: " + str(quest_id))
			continue
		
		var quest : QuestResource = database.get_quest(quest_id)
		var saved_state = saved_states[raw_id]
		if not saved_state is Dictionary: continue
		
		var saved_objectives = saved_state.get("objectives", {})
		if not saved_objectives is Dictionary: saved_objectives = {}
		
		var state : Dictionary = _get_or_create_state(quest_id)
		state["accepted"] = bool(saved_state.get("accepted", false))
		state["completed"] = bool(saved_state.get("completed", false))
		
		var objectives : Dictionary = state["objectives"]
		
		for objective in quest.objectives:
			if objective == null: continue
			
			var progress : int = int(saved_objectives.get(objective.id, 0))
			objectives[objective.id] = clamp(progress, 0, objective.required_amount)

func _save_progress() -> void:
	SaveManager.save_section("quests", get_save_data())

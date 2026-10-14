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
var _activating_subquests : Dictionary[StringName, bool] = {}

# --

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
	
	if is_accepted(quest_id) or is_completed(quest_id): return false
	
	if not _can_start_quest(quest_id): return false
	
	quest_accepted.emit(quest_id)
	_start_quest(quest_id)
	_save_progress()
	return true

func can_progress_objective(quest : QuestResource, objective_id : StringName) -> bool:
	if quest == null: return false
	if not is_accepted(quest.id) or is_completed(quest.id): return false
	
	var target : QuestObjective
	
	for objective in quest.objectives:
		if objective != null and objective.id == objective_id:
			target = objective
			break
	
	if target == null: return false
	if get_objective_progress(quest.id, objective_id) >= target.required_amount: return false
	
	match quest.objective_mode:
		QuestResource.ObjectiveMode.ALL:
			return true
		
		QuestResource.ObjectiveMode.SEQUENCE:
			var next_objective := _get_next_objective(quest)
			return next_objective != null and next_objective.id == objective_id
	
	return false

func _can_start_quest(quest_id : StringName) -> bool:
	var parent : QuestResource = _find_parent(quest_id, database.quests)
	if parent == null: return true
	
	if not is_accepted(parent.id) or is_completed(parent.id): return false
	
	match parent.subquest_mode:
		QuestResource.SubquestMode.ALL:
			return true
		
		QuestResource.SubquestMode.SEQUENCE:
			return _get_next_sequence_subquest(parent) == quest_id
		
		QuestResource.SubquestMode.RANDOM_SEQUENCE:
			return _get_active_random_subquest(parent) == quest_id
	
	return false

func _start_quest(quest_id : StringName) -> void:
	if is_accepted(quest_id) or is_completed(quest_id): return
	
	var state : Dictionary = _get_or_create_state(quest_id)
	if state.is_empty(): return
	
	state["accepted"] = true
	quest_state_changed.emit(quest_id)
	
	_activate_subquests(quest_id)
	_check_completition(quest_id)

func _activate_subquests(quest_id : StringName) -> void:
	if _activating_subquests.has(quest_id): return
	
	var quest : QuestResource = database.get_quest(quest_id)
	if quest == null or quest.subquests.is_empty(): return
	if not is_accepted(quest_id) or is_completed(quest_id): return
	
	_activating_subquests[quest_id] = true
	
	match quest.subquest_mode:
		QuestResource.SubquestMode.ALL:
			for subquest in quest.subquests:
				if subquest == null: continue
				if not is_completed(subquest.id): _start_quest(subquest.id)
		
		QuestResource.SubquestMode.SEQUENCE:
			while is_accepted(quest_id) and not is_completed(quest_id):
				var next_id : StringName = (_get_next_sequence_subquest(quest))
				if next_id == &"": break
				_start_quest(next_id)
				
				if not is_completed(next_id): break
		
		QuestResource.SubquestMode.RANDOM_SEQUENCE:
			while is_accepted(quest_id) and not is_completed(quest_id):
				var next_id : StringName = (_get_active_random_subquest(quest))
				if next_id == &"": break
				_start_quest(next_id)
				
				if not is_completed(next_id): break
	
	_activating_subquests.erase(quest_id)

func _get_next_sequence_subquest(quest : QuestResource) -> StringName:
	for subquest in quest.subquests:
		if subquest == null: continue
		if not is_completed(subquest.id): return subquest.id
	
	return &""

func _get_valid_subquest_count(quest : QuestResource) -> int:
	var count: int = 0
	for subquest in quest.subquests:
		if subquest != null: count += 1
	
	return count

func _get_active_random_subquest(quest : QuestResource) -> StringName:
	var completed_count : int = _get_completed_subquest_count(quest)
	var required : int = mini(quest.required_subquests, _get_valid_subquest_count(quest))
	
	if completed_count >= required:
		_set_active_random_subquest(quest.id, &"")
		return &""
	
	var state : Dictionary = _get_or_create_state(quest.id)
	
	if state.is_empty(): return &""
	
	var active_id : StringName = StringName(str(state.get("active_random_subquest", "")))
	if active_id != &"" and not is_completed(active_id):
		for subquest in quest.subquests:
			if not subquest == null and subquest.id == active_id:
				return active_id
	
	var candidates : Array[StringName] = []
	
	for subquest in quest.subquests:
		if subquest == null: continue
		if not is_completed(subquest.id): candidates.append(subquest.id)
	
	if candidates.is_empty():
		_set_active_random_subquest(quest.id, &"")
		return &""
	
	var selected_id : StringName = candidates.pick_random()
	_set_active_random_subquest(quest.id, selected_id)
	return selected_id

func _set_active_random_subquest(quest_id : StringName, subquest_id : StringName) -> void:
	var state : Dictionary = _get_or_create_state(quest_id)
	if state.is_empty(): return
	
	state["active_random_subquest"] = subquest_id

func _get_completed_subquest_count(quest : QuestResource) -> int:
	var count : int = 0
	
	for subquest in quest.subquests:
		if subquest != null and is_completed(subquest.id): count += 1
	
	return count

func _get_next_objective(quest: QuestResource) -> QuestObjective:
	if quest == null: return null
	
	for objective in quest.objectives:
		if objective == null: continue
		
		var progress : int = get_objective_progress(quest.id, objective.id)
		if progress < objective.required_amount: return objective
	
	return null

func _get_or_create_state(quest_id : StringName) -> Dictionary:
	if not _states.has(quest_id):
		var quest : QuestResource = database.get_quest(quest_id)
		if quest == null: return {}
		
		var objectives : Dictionary[StringName, int] = {}
		
		for objective in quest.objectives:
			if objective == null: continue
			objectives[objective.id] = 0
		
		_states[quest_id] = {
			"accepted": false,
			"completed": false,
			"objectives": objectives,
			"active_random_subquest": &""
		}
	
	return _states[quest_id]

func get_objective_progress(quest_id : StringName, objective_id : StringName) -> int:
	var state : Dictionary = _states.get(quest_id, {})
	var objectives : Dictionary = state.get("objectives", {})
	return int(objectives.get(objective_id, 0))

func get_active_subquests(quest_id : StringName) -> Array[QuestResource]:
	var result : Array[QuestResource] = []
	var quest : QuestResource = database.get_quest(quest_id)
	if quest == null or not is_accepted(quest_id): return result
	
	for subquest in quest.subquests:
		if subquest == null: continue
		if is_accepted(subquest.id) and not is_completed(subquest.id):
			result.append(subquest)
	
	return result

func get_active_subquest(quest_id : StringName) -> QuestResource:
	var quest : QuestResource = database.get_quest(quest_id)
	if quest == null or not is_accepted(quest_id): return null
	
	var active_id : StringName = &""
	
	match quest.subquest_mode:
		QuestResource.SubquestMode.SEQUENCE:
			active_id = _get_next_sequence_subquest(quest)
		
		QuestResource.SubquestMode.RANDOM_SEQUENCE:
			active_id = _get_active_random_subquest(quest)
		
		QuestResource.SubquestMode.ALL:
			return null
	
	if active_id == &"" or not is_accepted(active_id) or is_completed(active_id): return null
	return database.get_quest(active_id)

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
			if not can_progress_objective(quest, objective.id): continue
			
			var current : int = int(objectives.get(objective.id, 0))
			var next : int = mini(current + amount, objective.required_amount)
			
			if next == current: continue
			
			objectives[objective.id] = next
			changed = true
			
			objective_progress_changed.emit(
				quest_id,
				objective.id,
				next,
				objective.required_amount
			)
			
			if quest.objective_mode == QuestResource.ObjectiveMode.SEQUENCE: break
		
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
	
	if not _are_subquests_complete(quest): return false
	
	state["completed"] = true
	state["accepted"] = false
	
	quest_completed.emit(quest_id)
	quest_state_changed.emit(quest_id)
	
	var parent : QuestResource = _find_parent(quest_id, database.quests)
	if not parent == null:
		_activate_subquests(parent.id)
		_check_completition(parent.id)
	
	return true

func _are_subquests_complete(quest : QuestResource) -> bool:
	if quest.subquests.is_empty(): return true
	
	var total : int = _get_valid_subquest_count(quest)
	
	var completed_count : int = _get_completed_subquest_count(quest)
	
	match quest.subquest_mode:
		QuestResource.SubquestMode.ALL:
			return completed_count == total
			
		QuestResource.SubquestMode.SEQUENCE:
			return completed_count == total
			
		QuestResource.SubquestMode.RANDOM_SEQUENCE:
			var required : int = mini(quest.required_subquests, total)
			return completed_count >= required
	
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
	if not can_progress_objective(quest, objective_id): return false
	
	var current := get_objective_progress(quest_id, objective_id)
	var remaining : int = objective.required_amount - current
	
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
		var state : Dictionary = _states[quest_id].duplicate(true)
		var saved_objectives : Dictionary = {}
		var objectives : Dictionary = state.get("objectives", {})
		
		for objective_id in objectives:
			saved_objectives[str(objective_id)] = (objectives[objective_id])
		
		state["objectives"] = saved_objectives
		state["active_random_subquest"] = str(state.get("active_random_subquest", ""))
		
		saved_states[str(quest_id)] = state
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
		state["active_random_subquest"] = StringName(str(saved_state.get("active_random_subquest", "")))
		
		var objectives : Dictionary = state["objectives"]
		
		for objective in quest.objectives:
			if objective == null: continue
			
			var progress : int = int(saved_objectives.get(str(objective.id), 0))
			objectives[objective.id] = clampi(progress, 0, objective.required_amount)
	
	for quest_id in _states.keys():
		if is_accepted(quest_id): _activate_subquests(quest_id)

func _save_progress() -> void:
	SaveManager.save_section("quests", get_save_data())

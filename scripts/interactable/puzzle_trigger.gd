@tool
extends Interactable
class_name PuzzleTrigger

# --

enum Requirement {
	NONE,
	QUEST_ACCEPTED,
	QUEST_COMPLETED,
	OBJECTIVE_ACTIVE,
	OBJECTIVE_COMPLETED,
}

# --

@export var player : Player

@export_group("Quest")
@export_subgroup("Requirements", "quest_")
@export var quest_requirement : Requirement = Requirement.NONE:
	set(value):
		quest_requirement = value
		notify_property_list_changed()
@export var quest_required_quest_id : StringName
@export var quest_required_objective_id : StringName
@export_subgroup("Progress", "quest_")
@export var quest_event_id : StringName
@export_subgroup("Reward", "quest_")
@export var quest_reward_item : ItemResource:
	set(value):
		quest_reward_item = value
		notify_property_list_changed()
@export var quest_reward_quantity : int = 1

@export_group("Puzzle", "puzzle_")
@export_subgroup("Layers")
@export_file_path("*.tscn") var puzzle_scene : String
@export var puzzle_layer : CanvasLayer
@export var puzzle_subviewport : SubViewport
@export_subgroup("Dialogues")
@export var puzzle_finished_dialogue : String = "completed"
@export var puzzle_exited_dialogue : String = "exited"

# --

var is_completed : bool = false

var _active_puzzle : Node = null

# --

func _ready() -> void:
	if Engine.is_editor_hint(): return
	
	if quest_requirement != Requirement.NONE:
		QuestManager.quest_state_changed.connect(_on_quest_state_changed)
		QuestManager.objective_progress_changed.connect(_on_objective_progress_changed)
	
	_update_quest_state()
	super._ready()

func start_puzzle() -> void:
	if _active_puzzle != null: return
	
	if is_completed:
		DialogueManager.show_dialogue_balloon(dialogue_handler.dialogue, puzzle_finished_dialogue)
		return
	
	if puzzle_scene.is_empty():
		push_warning("PuzzleTrigger: No puzzle scene assigned.")
		return
	
	if puzzle_layer == null or puzzle_subviewport == null:
		push_warning("PuzzleTrigger: Puzzle layer or SubViewport is missing.")
		return
	
	var packed_scene : PackedScene = load(puzzle_scene) as PackedScene
	if packed_scene == null:
		push_warning("PuzzleTrigger: Couldn't load puzzle scene.")
		return
	
	var scene = packed_scene.instantiate()
	
	if not scene.has_signal("puzzle_won") or not scene.has_signal("puzzle_exited"):
		push_warning("PuzzleTrigger: Puzzle scene must have puzzle_won and puzzle_exited signals.")
		scene.free()
		return
	
	_active_puzzle = scene
	
	scene.puzzle_won.connect(_on_puzzle_won)
	scene.puzzle_exited.connect(_on_puzzle_exited)
	
	puzzle_subviewport.add_child(scene)
	puzzle_layer.visible = true
	
	if player != null:
		player.input.input_enabled = false

# --

func _close_puzzle() -> void:
	puzzle_layer.visible = false
	
	if player != null and is_instance_valid(player):
		player.input.input_enabled = true
	
	_active_puzzle = null

func _on_puzzle_won() -> void:
	_close_puzzle()
	
	is_completed = true
	can_interact = false
	
	if not quest_event_id.is_empty(): QuestManager.report_event(quest_event_id)
	
	_give_reward()
	
	DialogueManager.show_dialogue_balloon(dialogue_handler.dialogue, puzzle_finished_dialogue)

func _on_puzzle_exited() -> void:
	_close_puzzle()
	DialogueManager.show_dialogue_balloon(dialogue_handler.dialogue, puzzle_exited_dialogue)

func _give_reward() -> void:
	if quest_reward_item == null: return
	
	InventoryManager.add_items(quest_reward_item, quest_reward_quantity)
	QuestManager.report_item_collected(quest_reward_item.id, quest_reward_quantity)

# --

func _update_quest_state() -> void:
	match quest_requirement:
		Requirement.NONE: can_interact = true
		
		Requirement.QUEST_ACCEPTED:
			can_interact = (
				QuestManager.is_accepted(quest_required_quest_id)
				and not QuestManager.is_completed(quest_required_quest_id)
			)
		
		Requirement.QUEST_COMPLETED: can_interact = QuestManager.is_completed(quest_required_quest_id)
		
		Requirement.OBJECTIVE_ACTIVE:
			can_interact = false
			
			if QuestManager.database == null: return
			
			var quest : QuestResource = QuestManager.database.get_quest(quest_required_quest_id)
			if quest == null: return
			
			can_interact = QuestManager.can_progress_objective(quest, quest_required_objective_id)
		
		Requirement.OBJECTIVE_COMPLETED: can_interact = _is_objective_completed()

# --

func _on_quest_state_changed(changed_quest_id : StringName):
	if changed_quest_id != quest_required_quest_id: return
	
	_update_quest_state()

func _on_objective_progress_changed(changed_quest_id : StringName, _objective_id : StringName, _progress : int, _required : int) -> void:
	if changed_quest_id != quest_required_quest_id: return
	#if objective_id != quest_required_objective_id: return
	
	_update_quest_state()

# --
#
#func _process(_delta: float) -> void:
	#if Engine.is_editor_hint(): return
	#print(can_interact)

# --

func _is_objective_completed() -> bool:
	if QuestManager.database == null: return false
	
	var quest : QuestResource = QuestManager.database.get_quest(quest_required_quest_id)
	if quest == null: return false
	
	for objective in quest.objectives:
		if objective == null: continue
		if objective.id != quest_required_objective_id: continue
		
		return (QuestManager.get_objective_progress(quest_required_quest_id, quest_required_objective_id) >= objective.required_amount)
	
	return false

# --

func _validate_property(property: Dictionary) -> void:
	if property.name == "quest_required_quest_id":
		if quest_requirement == Requirement.NONE:
			property.usage &= ~PROPERTY_USAGE_EDITOR
			
	if property.name == "quest_required_objective_id":
		if quest_requirement != Requirement.OBJECTIVE_ACTIVE \
		and quest_requirement != Requirement.OBJECTIVE_COMPLETED:
			property.usage &= ~PROPERTY_USAGE_EDITOR

	if property.name == "quest_reward_quantity":
		if quest_reward_item == null:
			property.usage &= ~PROPERTY_USAGE_EDITOR

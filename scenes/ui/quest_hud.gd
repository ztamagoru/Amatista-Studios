extends Control

# --

@export_group("Quests", "quest_")
@export var quest_container : VBoxContainer
@export var quest_entry_scene : PackedScene

# --

func _ready() -> void:
	QuestManager.quest_accepted.connect(func(_a): update_quests())
	QuestManager.quest_completed.connect(func(_a): update_quests())
	QuestManager.quest_state_changed.connect(func(_a): update_quests())
	QuestManager.objective_progress_changed.connect(func(_a, _b, _c, _d): update_quests())
	
	DialogueManager.dialogue_started.connect(func(_a) -> void: self.hide())
	DialogueManager.dialogue_ended.connect(func(_a) -> void: self.show())
	
	update_quests()

func update_quests() -> void:
	var quests : Array[Dictionary] = QuestManager.get_active_quests_display_data()
	
	for child in quest_container.get_children(): child.queue_free()
	
	for quest_data in quests:
		var quest_entry : QuestEntry = quest_entry_scene.instantiate()
		quest_container.add_child(quest_entry)
		quest_entry.setup(quest_data)

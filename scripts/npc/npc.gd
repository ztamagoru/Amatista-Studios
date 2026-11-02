@icon("res://assets/icons/npc.svg")

extends CharacterBody3D
class_name NPC

# --

@export var dialogue_handler : DialogueHandler

@export_group("Diary Entry", "diary_")
@export var diary_entry_id : StringName

@export_group("Movement")
@export var nav_agent : NavigationAgent3D
@export var nav_region : NavigationRegion3D
@export var speed : float
@export var look_target : Node3D
@export var idle_timer : Timer

# --

var is_closest : bool = false

# --

func _ready() -> void:
	pass

func interact() -> void:
	if not diary_entry_id.is_empty():
		DiaryEntriesManager.unlock_entry(diary_entry_id)
	
	if dialogue_handler.dialogue != null:
		DialogueManager.show_dialogue_balloon(
			dialogue_handler.dialogue,
			"start",
			[self, dialogue_handler]
		)

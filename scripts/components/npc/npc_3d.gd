@icon("res://assets/icons/npc.svg")

extends CharacterBody3D
class_name NPC3D

# --

@export var dialogue_handler : DialogueHandler

@export_group("Diary Entry", "diary_")
@export var diary_entry_id : StringName

@export_group("Movement")
@export var speed : float
@export_subgroup("Navigation", "nav_")
@export var nav_agent : NavigationAgent3D
@export var nav_region : NavigationRegion3D

@export_group("Target", "target_")
@export var target_look : Node3D
@export var target_detection_area : Area3D

@export_group("Animations")
@export var anim_tree : AnimationTree

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

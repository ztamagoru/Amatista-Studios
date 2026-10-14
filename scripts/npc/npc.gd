@icon("res://assets/icons/npc.svg")

extends CharacterBody3D
class_name NPC

# --

@export var dialogue_handler : DialogueHandler

@export_group("Movement")
@export var nav_agent : NavigationAgent3D
@export var nav_region : NavigationRegion3D
@export var speed : float
@export var look_target : Node3D
@export var idle_timer : Timer

# --

var is_closest : bool = false:
	set(value):
		if value != is_closest:
			is_closest = value
			toggle_ui_interaction()

# --

func _ready() -> void:
	pass

func interact() -> void:
	pass

func toggle_ui_interaction() -> void:
	pass

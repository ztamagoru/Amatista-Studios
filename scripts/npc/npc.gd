@icon("res://assets/icons/npc.svg")

extends CharacterBody3D
class_name NPC

# --

@export var dialogue_handler : DialogueHandler

# --

func _ready() -> void:
	pass

func interact() -> void:
	pass

func get_interaction_type() -> InteractionMarker.IndicatorType:
	if dialogue_handler == null:
		return InteractionMarker.IndicatorType.NONE
	
	return InteractionMarker.IndicatorType.DIALOGUE

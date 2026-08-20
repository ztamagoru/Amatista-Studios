extends Node

# --

signal set_interactable_outline(object_id : int)
signal hide_interactable_outline

# --

var player : CharacterBody3D

var current_trees : Array[Sick_Environment] = []

# --

func get_event_key(event_name : String):
	for input in InputMap.action_get_events(event_name):
		return input.as_text_physical_keycode()

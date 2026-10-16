@icon("res://assets/icons/checkerboard_circle.svg")
extends Node3D
class_name Level

# --

signal transition_state_changed()

# --

@export var adjacent_maps : Array[String]

# --

var game_manager : GameManager

var transitioning : bool = true

# --

func change_scene(target_scene : String) -> bool:
	if game_manager == null: return false
	
	transitioning = true
	
	game_manager.change_map(target_scene)
	return true

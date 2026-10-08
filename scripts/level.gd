@icon("res://assets/icons/checkerboard_circle.svg")
extends Node3D
class_name Level

# --

signal change_level(String)

# --

@export var adjacent_maps : Array[String]

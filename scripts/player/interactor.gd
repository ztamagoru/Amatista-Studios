extends Area3D
class_name Interactor

# --

@onready var parent : CharacterBody3D = get_parent()

var last_dir : Vector2

# --

func _physics_process(delta: float) -> void:
	
	var test = get_overlapping_areas()
	test.sort_custom(func(a,b): return a.global_position.distance_to(global_position) < b.global_position.distance_to(global_position))

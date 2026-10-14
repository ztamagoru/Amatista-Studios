extends Area3D
class_name Interactor

# --

@onready var parent : CharacterBody3D = get_parent()

# --

var last_dir : Vector2

var closest_target : Node3D

# --

func _physics_process(_delta: float) -> void:
	var candidates : Array[Node3D] = []
	
	for area in get_overlapping_areas():
		if area is Interactable and area.can_interact:
			candidates.append(area)
	
	for body in get_overlapping_bodies():
		if body is NPC and body.dialogue_handler != null:
			candidates.append(body)
	
	candidates.sort_custom(func(a,b): return a.global_position.distance_to(global_position) < b.global_position.distance_to(global_position))
	
	var new_target : Node3D = null
	
	if not candidates.is_empty(): new_target = candidates[0]
	
	if new_target == closest_target: return
	
	if is_instance_valid(closest_target):
		closest_target.is_closest = false
	
	closest_target = new_target
	
	if is_instance_valid(closest_target):
		closest_target.is_closest = true
	

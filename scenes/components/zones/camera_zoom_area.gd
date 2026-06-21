@icon("res://assets/icons/zoom.svg")

extends Marker3D
class_name CameraZoomArea

# --

@export var player : CharacterBody3D

@export_group("Distances")
@export_range(0.0, 25.0, 1.0) var min_distance : float = 10.0
@export_range(30.0, 50.0, 1.0) var max_distance : float = 35.0

@export_group("Camera Settings")
@export var camera : Node3D
@export var camera_position : Vector3 = Vector3(8.0, 20.0, 20.0)
@export var camera_rotation : Vector3 = Vector3(-30.0, 0.0, 0.0)

# --

var zoom_start_position  : Vector3
var zoom_start_rotation  : Vector3

var expected_cam_position : Vector3
var expected_cam_rotation : Vector3

var player_in_range : bool
var was_in_range : bool = false

# --

func _physics_process(delta: float) -> void:
	if not player: return
	
	var pos_player : Vector3 = player.global_position * Vector3(1,0,1)
	var dist_from_player : float = global_position.distance_to(pos_player)
	
	player_in_range = dist_from_player <= max_distance
	
	if player_in_range and not was_in_range:
		zoom_start_position = camera.pivot.position
		zoom_start_rotation = camera.pivot.rotation_degrees
	
	if not player_in_range:
		if was_in_range:
			camera.pivot.position = camera.pivot.position.move_toward(
				zoom_start_position,
				delta * camera.pivot.position.distance_to(zoom_start_position)
			)
			
			camera.pivot.rotation_degrees = camera.pivot.rotation_degrees.move_toward(
				zoom_start_rotation,
				delta * camera.pivot.rotation_degrees.distance_to(zoom_start_rotation)
			)
		
		was_in_range = player_in_range
		return
	
	dist_from_player = clamp(dist_from_player, min_distance, max_distance)
	var blend : float = remap(dist_from_player, min_distance, max_distance, 0, 1) 
	
	expected_cam_position = camera_position.lerp(zoom_start_position, blend)
	camera.pivot.position = camera.pivot.position.move_toward(
		expected_cam_position,
		delta * camera.pivot.position.distance_to(expected_cam_position)
	)
	
	expected_cam_rotation = camera_rotation.lerp(zoom_start_rotation, blend)
	camera.pivot.rotation_degrees = camera.pivot.rotation_degrees.move_toward(
		expected_cam_rotation,
		delta * camera.pivot.rotation_degrees.distance_to(expected_cam_rotation)
	)
	
	was_in_range = player_in_range

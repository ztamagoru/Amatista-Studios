extends Node3D

# --

@export var player : CharacterBody3D
@export var camera : Camera3D
@export var pivot : Node3D

# --

const max_pitch : float = 0.3
const max_yaw : float = 0.5

var camera_original_rotation : Vector3

var pivot_original_position : Vector3
var pivot_original_rotation : Vector3

var tween : Tween
const tween_duration : float = 1.0

# --

func _ready():
	camera_original_rotation = camera.rotation_degrees
	
	pivot_original_position = pivot.position
	pivot_original_rotation = pivot.rotation_degrees

func _process(_delta: float):
	if player:
		self.global_position = player.global_position
	
	var mouse_pos : Vector2 = get_viewport().get_mouse_position()
	var screen_center : Vector2 = get_viewport().size / 2.0
	
	var direction : Vector2 = mouse_pos - screen_center
	
	direction = direction / screen_center
	
	camera.rotation_degrees = Vector3(
		camera_original_rotation.x - direction.y * max_pitch,
		camera_original_rotation.y - direction.x * max_yaw,
		camera_original_rotation.z
	)

func move_camera(new_position : Vector3, new_rotation : Vector3):
	if tween: tween.kill()
	
	tween = create_tween()
	tween.set_parallel(true)
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(pivot, "position", new_position, tween_duration)
	tween.tween_property(pivot, "rotation_degrees", new_rotation, tween_duration)

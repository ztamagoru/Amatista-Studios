extends Node3D

# --

var max_pitch : float = 1.25
var max_yaw : float = 1.5

var original_rotation : Vector3

# --

func _ready():
	original_rotation = rotation_degrees

func _process(delta: float):
	var mouse_pos : Vector2 = get_viewport().get_mouse_position()
	var screen_center : Vector2 = get_viewport().size / 2.0
	
	var direction : Vector2 = mouse_pos - screen_center
	
	direction = direction / screen_center
	
	rotation_degrees = Vector3(
		original_rotation.x - direction.y * max_pitch,
		original_rotation.y - direction.x * max_yaw,
		original_rotation.z
	)

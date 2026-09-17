extends Node3D
class_name PlayerInput

# --

var move_dir : Vector2
var aim_dir : Vector2

var is_running : bool
var is_jumping : bool

# --

func _init() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CONFINED_HIDDEN

func _input(event: InputEvent) -> void:
	
	# Movement
	move_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_backwards")
	
	# Aim
	var aim_vector = Input.get_vector("aim_left", "aim_right", "aim_forward", "aim_backwards")
	if aim_vector.length() > 0:
		aim_dir = aim_vector
	elif Input.is_action_pressed("mouse_click"):
		if event is InputEventMouseMotion:
			aim_dir += event.relative * 0.01
	else:
		aim_dir = Vector2.ZERO
	
	# Run
	if event.is_action_pressed("move_run"):
		is_running = true
	elif event.is_action_released("move_run"):
		is_running = false
	
	# Jump
	if event.is_action_pressed("move_jump"):
		is_jumping = true
	elif event.is_action_released("move_jump"):
		is_jumping = false

# --

func is_aiming() -> bool:
	return aim_dir.length() > 0.1

# --

func get_movement_direction() -> Vector3:
	var camera := get_viewport().get_camera_3d()
	return (camera.basis * Vector3(move_dir.x, 0, move_dir.y)).limit_length()

func get_aiming_direction() -> Vector3:
	var camera := get_viewport().get_camera_3d()
	return (camera.basis * Vector3(aim_dir.x, 0, aim_dir.y)).limit_length()

extends Node3D
class_name PlayerMovement

# --

@onready var player : Player = get_parent()

# --

var speed_progress : float

# --

func move(delta : float, settings : MovementSettings) -> void:
	if !player.is_on_floor():
		player.velocity += player.get_gravity() * delta
	
	var dir = player.input.get_movement_direction()
	
	var desired_vel = dir * settings.max_speed
	var current_vel = player.velocity.slide(Vector3.UP)
	var vel_dif = desired_vel - current_vel
	
	var acceleration = settings.acceleration if dir.length() > 0 else settings.deceleration
	
	player.velocity += vel_dif * acceleration * delta
	
	player.move_and_slide()
	
	speed_progress = player.velocity.slide(Vector3.UP).length() / settings.max_speed

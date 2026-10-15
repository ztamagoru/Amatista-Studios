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
	
	var dir = player.input.get_movement_direction().slide(Vector3.UP).limit_length()
	
	var desired_vel = dir * settings.max_speed
	var current_vel = player.velocity.slide(Vector3.UP)
	var vel_dif = desired_vel - current_vel
	
	var acceleration = settings.acceleration if dir.length() > 0 else settings.deceleration
	
	player.velocity += vel_dif * acceleration * delta
	
	player.move_and_slide()
	
	speed_progress = player.velocity.slide(Vector3.UP).length() / settings.max_speed

	var is_moving := player.velocity.slide(Vector3.UP).length() > 0.1 and player.is_on_floor()
	_update_footsteps(delta, is_moving)

@onready var ground_ray: RayCast3D = $"../RayCast3D"
var _step_timer: float = 0.0
@export var step_interval: float = 0.4

func _update_footsteps(delta: float, is_moving: bool) -> void:
	#print("FOOTSTEPS -> llamada, is_moving: ", is_moving)
	if not is_moving:
		_step_timer = 0.0
		return
	_step_timer -= delta
	if _step_timer <= 0.0:
		_step_timer = step_interval
		var surface := _detect_surface()
		print("PLAYER -> Detectó superficie: ", surface)
		AudioManager.on_footstep(surface)

func _detect_surface() -> String:
	if not ground_ray.is_colliding():
		print("No collisiona con nada")
		return "Grass"
	var collider := ground_ray.get_collider()
	if collider.is_in_group("Grass"):
		return "Grass"
	if collider.is_in_group("Dirt"):
		return "Dirt"
	if collider.is_in_group("Wood"):
		return "Wood"
	return "Grass"

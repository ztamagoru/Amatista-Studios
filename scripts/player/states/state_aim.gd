extends State

# --

@export var movement_settings : MovementSettings
@export var aim_target : Node3D
@export var aim_distance : float = 10

# --

var last_aim_dir : Vector2

var last_aimed_dir : Vector3
const projectile_scene = preload("res://scenes/components/projectile.tscn")


# --

func state_phys_process(_delta : float) -> void:
	var player := root as Player
	
	player.movement.move(_delta, movement_settings)
	
	aim_target.global_position = player.global_position + player.input.get_aiming_direction().slide(Vector3.UP) * aim_distance
	last_aimed_dir = aim_target.global_position
	
	if player.input.aim_dir.length() > 0:
		last_aim_dir = player.input.aim_dir

func state_exit() -> void:
	var player := root as Player

	print("Shoot!")
	
	var projectile : Projectile = projectile_scene.instantiate()
	projectile.setup(player.global_position, last_aimed_dir)
	get_tree().current_scene.add_child(projectile)
	
	last_aim_dir = Vector2.ZERO

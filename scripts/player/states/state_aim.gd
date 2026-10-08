extends State

# --

signal aimed
signal unaimed

# --

@export var shot_source : Node3D

@export var aim_target : Node3D
@export var aim_distance : float = 10

# --

const projectile_scene = preload("res://scenes/components/projectile.tscn")

# --

func state_enter() -> void:
	aimed.emit()

func state_phys_process(_delta : float) -> void:
	var player := root as Player
	
	aim_target.global_position = player.global_position + player.input.get_aiming_direction().slide(Vector3.UP) * aim_distance


func state_exit() -> void:
	var player := root as Player
	
	var projectile : Projectile = projectile_scene.instantiate()
	get_tree().current_scene.add_child(projectile)
	projectile.shoot(shot_source.global_position, aim_target.global_position)
	
	unaimed.emit()

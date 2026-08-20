extends Node3D

# --

@export var area_end : Area3D
@export var garden_scene : PackedScene

# --

@export_category("Z Boundary")
@export var player : CharacterBody3D
@export var z_boundary : CollisionShape3D

const boundary_step : float = 32
var boundary_furthest : float

# --

@export_category("Incremental Fog")
@export var world_environment : WorldEnvironment
@export var fog_min_density : float
@export var fog_max_density : float
@export var fog_start_z : float
@export var fog_end_z : float

var env : Environment

# --

func _ready():
	area_end.body_entered.connect(end_tutorial)
	
	env = world_environment.environment
	boundary_furthest = player.global_position.z
	
	env.fog_enabled = true

func _process(_delta: float):
	var progress := inverse_lerp(fog_start_z, fog_end_z, player.global_position.z)
	progress = clamp(progress, 0.0, 1.0)
	
	env.fog_density = lerp(
		fog_min_density,
		fog_max_density,
		progress
	)

func _physics_process(_delta: float):
	if player.global_position.z < boundary_furthest:
		boundary_furthest = player.global_position.z
		z_boundary.global_position.z = boundary_furthest + boundary_step

func end_tutorial(body : Node3D):
	if body.is_in_group("player"):
		get_tree().change_scene_to_packed(garden_scene)

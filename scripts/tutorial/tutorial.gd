extends Node3D

# --

@export var area_end : Area3D
@export var garden_scene : PackedScene

# --

@export_category("Dialogs")
@export var tutorial_movement : DialogueResource

@export_category("Lucy Pudu")
@export var lucy : CharacterBody3D
@export var lucy_mov_speed : float
@export var lucy_rot_speed : float
@export var lucy_final_pos : Vector3
@export var lucy_signal_area : Area3D

var _is_lucy_running : bool = false

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
	lucy_signal_area.body_entered.connect(lucy_run)
	
	env = world_environment.environment
	boundary_furthest = player.global_position.z
	
	env.fog_enabled = true
	
	# --
	
	await get_tree().process_frame
	
	DialogueManager.show_dialogue_balloon(tutorial_movement, "movement")

func _process(_delta: float):
	var progress := inverse_lerp(fog_start_z, fog_end_z, player.global_position.z)
	progress = clamp(progress, 0.0, 1.0)
	
	env.fog_density = lerp(
		fog_min_density,
		fog_max_density,
		progress
	)

func _physics_process(delta: float):
	if player.global_position.z < boundary_furthest:
		boundary_furthest = player.global_position.z
		z_boundary.global_position.z = boundary_furthest + boundary_step
	
	if not _is_lucy_running:
		return
	
	var current_rotation = lucy.global_transform.basis.get_rotation_quaternion()
	var target_rotation = lucy.basis.looking_at(lucy_final_pos, Vector3.UP).get_rotation_quaternion()
	var new_rotation = current_rotation.slerp(target_rotation, lucy_rot_speed * delta)
	
	lucy.global_transform.basis = Basis(new_rotation)
	
	var direction := lucy.global_position.direction_to(lucy_final_pos)
	
	if lucy.global_position.distance_to(lucy_final_pos) <= 0.1:
		_is_lucy_running = false
		return
	
	lucy.velocity = direction * lucy_mov_speed
	lucy.move_and_slide()

func end_tutorial(body : Node3D):
	if body.is_in_group("player"):
		get_tree().change_scene_to_packed(garden_scene)

func lucy_run(body : Node3D):
	if body.is_in_group("player"):
		lucy_signal_area.get_child(0).disabled = true
		_is_lucy_running = true

extends Node3D
class_name PlayerVisuals

# --

@onready var player : Player = get_parent()
@onready var anim_tree : AnimationTree = $AnimationTree

# --

@export var aim_target_mesh : MeshInstance3D

# --

var current_state : StringName: 
	get():
		return player.state_machine.current_state.name

# --

func _physics_process(_delta: float) -> void:
	
	anim_tree.set("parameters/MovementBlend/blend_position", player.movement.speed_progress)
	
	if player.velocity.slide(Vector3.UP).length() > 0.1:
		look_at(global_position + -player.velocity.slide(Vector3.UP))
	
	if current_state == "Aim":
		look_at(global_position - player.input.get_aiming_direction().slide(Vector3.UP))


func _on_aim_aimed() -> void:
	var tween = create_tween()
	tween.tween_property(aim_target_mesh.get_active_material(0), "albedo_color", Color.RED, 0.5)


func _on_aim_unaimed() -> void:
	var tween = create_tween()
	tween.tween_property(aim_target_mesh.get_active_material(0), "albedo_color", Color.TRANSPARENT, 0.5)

# --

func footstep() -> void:
	var surface := detect_surface()
	print("PLAYER -> Detectó superficie: ", surface)
	AudioManager.on_footstep(surface)


@onready var ground_ray: RayCast3D = $"../RayCast3D"

func detect_surface() -> String:
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

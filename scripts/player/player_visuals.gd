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

func _physics_process(delta: float) -> void:
	
	anim_tree.set("parameters/MovementBlend/blend_position", player.movement.speed_progress)
	
	if player.velocity.slide(Vector3.UP).length() > 0.1:
		look_at(global_position + -player.velocity.slide(Vector3.UP))


func _on_aim_aimed() -> void:
	var tween = create_tween()
	tween.tween_property(aim_target_mesh.get_active_material(0), "albedo_color", Color.RED, 0.5)


func _on_aim_unaimed() -> void:
	var tween = create_tween()
	tween.tween_property(aim_target_mesh.get_active_material(0), "albedo_color", Color.TRANSPARENT, 0.5)

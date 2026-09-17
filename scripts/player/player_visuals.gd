extends Node3D
class_name PlayerVisuals

# --

@onready var player : Player = get_parent()

@onready var anim_tree : AnimationTree = $AnimationTree
@onready var skeleton : Skeleton3D = $Rogue/Rig_Medium/Skeleton3D

@onready var look_at_modifier : LookAtModifier3D = $Rogue/Rig_Medium/Skeleton3D/LookAtModifier3D

# --

@export_category("Aim")
@export var aim_target : Node3D
# --

func _physics_process(delta: float) -> void:
	
	# Movement
	anim_tree.set("parameters/MoveMachine/MovementBlend/blend_position", player.movement.speed_progress)
	
	# Aiming
	if player.state_machine.current_state.name == "Aim":
		anim_tree.set("parameters/AimBlend/blend_amount", 1)
		anim_tree.set("parameters/AimTimeSeek/seek_request", player.input.aim_dir.length() * 0.5)
		
		look_at_modifier.influence = player.input.aim_dir.length()
	else:
		anim_tree.set("parameters/AimBlend/blend_amount", 0)
		look_at_modifier.influence = 0
	
	# Look towards speed
	if player.velocity.slide(Vector3.UP).length() > 0.1:
		look_at(global_position + -player.velocity.slide(Vector3.UP))

# --

func on_step() -> void:
	pass

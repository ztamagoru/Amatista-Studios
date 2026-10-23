extends Node3D
class_name PlayerVisuals

# --

@onready var player : Player = get_parent()
@onready var anim_player : AnimationPlayer = $AnimationPlayer

# --

func _physics_process(delta: float) -> void:
	if player.velocity.slide(Vector3.UP).length() > 5:
		anim_player.play("Movement")
	else:
		anim_player.play("Idle")
	
	var desired_rot_degrees = Vector3.UP * (180 if player.velocity.z > 0 else 0)
	rotation_degrees = lerp(rotation_degrees, desired_rot_degrees, 10 * delta)

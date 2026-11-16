extends Area3D
class_name HurtBox

# --

@onready var parent : Node3D = get_parent()

# --

func hit() -> void:
	var tween = create_tween().set_trans(Tween.TRANS_SINE	)
	tween.tween_property(parent, "scale", Vector3(1, 0.95, 1), 0.1)
	tween.tween_property(parent, "scale", Vector3(1, 1, 1), 0.1)

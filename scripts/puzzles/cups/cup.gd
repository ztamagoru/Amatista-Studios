extends Node3D
class_name Cup

# -- 

@export var anim : AnimationPlayer

# --

func _process(_delta: float) -> void:
	global_basis = Basis.IDENTITY

func check_inside():
	anim.play("check_inside")

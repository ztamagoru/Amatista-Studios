extends Area3D
class_name Cup

# -- 

@export var anim : AnimationPlayer
@export var object_mesh : MeshInstance3D

# --

var prize_scene : PackedScene = preload("res://scenes/components/puzzles/shell_game_prize.tscn")

var has_item : bool = false

# --

func _process(_delta: float) -> void:
	global_basis = Basis.IDENTITY

func check_inside():
	anim.play("check_inside")

func chosen_cup():
	has_item = true
	
	var prize = prize_scene.instantiate()
	
	add_child(prize)

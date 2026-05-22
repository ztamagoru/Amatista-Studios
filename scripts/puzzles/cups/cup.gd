extends Area3D
class_name Cup

# -- 

@export var anim : AnimationPlayer
@export var object_mesh : MeshInstance3D

# --

var outline_material : StandardMaterial3D = preload("res://scripts/interactable/outline_material_3d.tres")
var prize_scene : PackedScene = preload("res://scenes/components/puzzles/shell_game_prize.tscn")

var _is_interactable : bool = false

var has_item : bool = false

# --

func _ready() -> void:
	Globals.set_interactable_outline.connect(show_outline)
	Globals.hide_interactable_outline.connect(hide_outline)
	
	object_mesh.set_surface_override_material(2, object_mesh.get_active_material(2).duplicate())

func _process(_delta: float) -> void:
	global_basis = Basis.IDENTITY

func check_inside():
	anim.play("check_inside")

func hide_outline():
	if _is_interactable: _is_interactable = false
	object_mesh.get_active_material(2).next_pass = null

func show_outline(object_id : int):
	if self.get_instance_id() == object_id:
		_is_interactable = true
		object_mesh.get_active_material(2).next_pass = outline_material

func chosen_cup():
	has_item = true
	
	var prize = prize_scene.instantiate()
	
	add_child(prize)

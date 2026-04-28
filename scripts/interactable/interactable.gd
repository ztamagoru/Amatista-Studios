extends Node3D
class_name Interactable

# --

var outline_material : StandardMaterial3D = preload("res://scripts/interactable/outline_material_3d.tres")

# --

@export var object_mesh : MeshInstance3D

# --

func _ready():
	object_mesh.material_overlay = outline_material

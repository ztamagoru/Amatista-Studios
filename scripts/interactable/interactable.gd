extends Node3D
class_name Interactable

# --

@export var object_mesh : MeshInstance3D

@export_file_path("*.dialogue") var dialogue : String 
@export var dialogue_route : DialogueResource


# --

var outline_material : StandardMaterial3D = preload("res://scripts/interactable/outline_material_3d.tres")

var _is_interactable : bool = false

# --

func _ready():
	Globals.set_interactable_outline.connect(show_outline)
	Globals.hide_interactable_outline.connect(hide_outline)

func hide_outline():
	if _is_interactable: _is_interactable = false
	object_mesh.material_overlay = null

func show_outline(object_id : int):
	if self.get_instance_id() == object_id:
		_is_interactable = true
		object_mesh.material_overlay = outline_material

func _process(_delta: float) -> void:
	if _is_interactable and Input.is_action_just_pressed("interact"):
		if dialogue_route:
			DialogueManager.show_dialogue_balloon(dialogue_route, "start")

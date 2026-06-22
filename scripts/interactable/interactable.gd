@tool

extends CharacterBody3D
class_name Interactable

# --

@export_group("Can_Interact")
@export var can_interact : bool = false
@export var object_meshes : Array[MeshInstance3D]
@export var mesh_material : int = 0

@export_group("Dialog")
@export_custom(PROPERTY_HINT_GROUP_ENABLE, "") var has_dialog : bool = false
@export var first_time_dialog : bool = true
@export var dialogue : DialogueResource
@export_file_path("*.dialogue") var dialogue_route : String 

# --

var outline_material : StandardMaterial3D = preload("res://scripts/interactable/outline_material_3d.tres")

var _is_interacting : bool = false

var _can_start_dialog : bool = true

var outline_mat_passes : Array[StandardMaterial3D] = []

# --

func _ready():
	add_to_group("interactable")
	
	connect_signals()
	outline()
	Globals.set_interactable_outline.connect(show_outline)
	Globals.hide_interactable_outline.connect(hide_outline)
	
	DialogueManager.dialogue_started.connect(_dialog_started)
	DialogueManager.dialogue_ended.connect(_dialog_ended)

func outline():
	for object_mesh in object_meshes:
		for i in range(object_mesh.mesh.get_surface_count()):
			if object_mesh.mesh.surface_get_material(i) is StandardMaterial3D:
				var new_mat : StandardMaterial3D = StandardMaterial3D.new()
				new_mat = object_mesh.mesh.surface_get_material(i)
				
				object_mesh.set_surface_override_material(i, new_mat)
				outline_mat_passes.append(new_mat)
	

func _process(_delta: float) -> void:
	if _is_interacting and Input.is_action_just_pressed("interact") and _can_start_dialog:
		if dialogue_route: DialogueManager.show_dialogue_balloon(dialogue, "start", [self])

func hide_outline():
	if _is_interacting: _is_interacting = false
	
	for i in outline_mat_passes:
		i.next_pass = null

func show_outline(object_id : int):
	if self.get_instance_id() == object_id:
		_is_interacting = true
		
		for i in outline_mat_passes:
			i.next_pass = outline_material

func _dialog_started(_resource: DialogueResource):
	_can_start_dialog = false
	pass

func _dialog_ended(_resource: DialogueResource):
	_can_start_dialog = true
	pass

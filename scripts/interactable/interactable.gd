@icon("res://assets/icons/tap.svg")

extends Area3D
class_name Interactable

# --

@export var dialogue_handler : DialogueHandler

@export var object_meshes : Array[MeshInstance3D]

# --

var can_interact : bool = true
var is_closest : bool = false:
	set(value):
		if value == is_closest: return
		
		is_closest = value
		_toggle_outline()
		toggle_ui_interaction()

var outline_material : StandardMaterial3D = load("res://resources/outline_material_3d.tres")
var override_materials : Array[StandardMaterial3D]

# --

func _ready() -> void:
	_add_outline()

func _process(_delta: float) -> void:
	pass

# --

func _add_outline() -> void:
	if object_meshes.is_empty(): return
	
	for object_mesh in object_meshes:
		if object_mesh == null: continue
		
		for i in range(object_mesh.mesh.get_surface_count()):
			var material := object_mesh.mesh.surface_get_material(i)
			
			if material is StandardMaterial3D:
				var override_material : StandardMaterial3D = material.duplicate()
				
				object_mesh.set_surface_override_material(i, override_material)
				override_materials.append(override_material) 

func _toggle_outline() -> void:
	if override_materials.is_empty(): return
	for i in override_materials:
		i.next_pass = outline_material if is_closest else null

func _execute_dialogue(triggered_by : Interactable, dialogue_position : String = "start") -> void:
	if dialogue_handler != null and dialogue_handler.dialogue != null:
		DialogueManager.show_dialogue_balloon(
			dialogue_handler.dialogue,
			dialogue_position,
			[triggered_by, dialogue_handler]
		)

func _update_quest_state() -> void:
	pass

func toggle_ui_interaction() -> void:
	pass

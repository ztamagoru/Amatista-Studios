extends Node3D
class_name Sick_Environment

# --

@export var mesh : MeshInstance3D 

@export_group("Shader Settings", "shader_")
@export var shader_sick_texture : Image
@export var shader_cured_texture : Image

# --

var shader_script : Shader = preload("res://test.gdshader")

var _is_cured : bool = false  

# --

func _process(_delta: float) -> void:
	if _is_cured:
		pass

func collision():
	if not _is_cured:
		_is_cured = not _is_cured
		
		var new_shader_material : ShaderMaterial = ShaderMaterial.new()
		
		new_shader_material.shader = shader_script
		
		mesh.set_surface_override_material(0, new_shader_material)
		
		#var new_tex = load("res://icon.svg")
		#
		#var new_material : StandardMaterial3D = StandardMaterial3D.new()
		#new_material.albedo_texture = new_tex
		#mesh.set_surface_override_material(0, new_material)

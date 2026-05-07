extends Node3D
class_name Sick_Environment

# --

@export var mesh : MeshInstance3D 

# --

const transition_time : float = 1.25

var shader_material : ShaderMaterial
var shader_blend : float

var _is_cured : bool = false  

# --

func _ready() -> void:
	shader_material = mesh.get_surface_override_material(0)
	

func _process(delta: float) -> void:
	if _is_cured:
		if not shader_blend: 
			shader_material.get_shader_parameter("blend")
		elif shader_blend >= transition_time:
			return
		
		shader_blend += transition_time * delta
		shader_material.set_shader_parameter("blend", shader_blend)

func collision():
	if not _is_cured:
		_is_cured = not _is_cured

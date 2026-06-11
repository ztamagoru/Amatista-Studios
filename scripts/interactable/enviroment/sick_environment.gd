extends Node3D
class_name Sick_Environment

# --

var tree_shader : Shader = preload("res://scripts/interactable/enviroment/tree.gdshader") 
var leaves_shader : Shader = preload("res://scripts/interactable/enviroment/leaves.gdshader") 

@export var mesh : MeshInstance3D 

@export var has_leaves : bool
@export var leaves_surface : int = 0

@export_group("Textures", "texture_")
@export var texture_healthy : Array[Texture] = []
@export var texture_sick : Array[Texture] = []

# --

const transition_time : float = 1.25

var shader_blend : float = 0.0

var _is_cured : bool = false  

var player : CharacterBody3D
var camera : Camera3D

var shader_passes : Array[ShaderMaterial] = []

# --

func _ready() -> void:
	var p = get_tree().get_first_node_in_group("player")
	if p is CharacterBody3D: player = p
	camera = get_viewport().get_camera_3d()
	
	var object_mesh : Mesh = mesh.mesh 
	for i in range(object_mesh.get_surface_count()):
		if object_mesh.surface_get_material(i) is StandardMaterial3D:
			var shader_mat : ShaderMaterial = ShaderMaterial.new()
			
			print(mesh.name)
			print("index:" + str(i))
			print("leaves in:" + str(leaves_surface))
			shader_mat.shader = leaves_shader if has_leaves and leaves_surface == i else tree_shader
			
			shader_mat.set_shader_parameter(
				"texture_a",
				texture_sick[i]
			)
			
			shader_mat.set_shader_parameter(
				"texture_b",
				texture_healthy[i]
			)
			
			mesh.set_surface_override_material(i, shader_mat)
			shader_passes.append(shader_mat)
	

func _process(delta: float) -> void:
	if !player or !camera:
		return
	
	var camera_forward : Vector3 = camera.global_transform.basis.z
	var screen_pos = camera.unproject_position(
		player.global_position + Vector3.UP * 1.25
	)
	
	var viewport_size = get_viewport().get_visible_rect().size
	var screen_uv = screen_pos / viewport_size
	
	for shader in shader_passes:
		shader.set_shader_parameter("player_screen_pos", screen_uv)
		shader.set_shader_parameter("player_position", player.global_transform.origin)
		shader.set_shader_parameter("camera_forward", camera_forward)
	
	if not _is_cured:
		return
	
	if shader_blend >= transition_time:
		return
	
	shader_blend += transition_time * delta / 5
	for i in shader_passes:
		i.set_shader_parameter("blend", shader_blend)

func collision():
	if not _is_cured:
		_is_cured = not _is_cured

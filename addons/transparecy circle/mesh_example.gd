extends MeshInstance3D

# -- 

var transparency_shader : Shader = preload("res://addons/transparecy circle/transparency_circle.gdshader")
#var transparency_shader : Shader = preload("res://test.gdshader")

var player : CharacterBody3D
var camera : Camera3D

var shader_passes : Array[ShaderMaterial] = []

# --

func _ready() -> void:
	var p = get_tree().get_first_node_in_group("player")
	if p is CharacterBody3D: player = p
	camera = get_viewport().get_camera_3d()
	
	for i in range(mesh.get_surface_count()):
		if mesh.surface_get_material(i) is StandardMaterial3D:
			var transparency_mat : ShaderMaterial = ShaderMaterial.new()
			transparency_mat.shader = transparency_shader
			
			transparency_mat.set_shader_parameter(
				"albedo_texture",
				mesh.surface_get_material(i).albedo_texture
			)
			
			set_surface_override_material(i, transparency_mat)
			shader_passes.append(transparency_mat)

func _process(delta):
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

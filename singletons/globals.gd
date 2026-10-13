extends Node

# --

var player : CharacterBody3D

var camera : Node3D

# --

var brightness: float = 1.0

var post_processing_material: ShaderMaterial

# --

func register_post_processing(material: ShaderMaterial) -> void:
	post_processing_material = material
	_apply_post_processing()

func unregister_post_processing(material: ShaderMaterial) -> void:
	if post_processing_material == material:
		post_processing_material = null

func set_brightness(value : float) -> void:
	brightness = clampf(value, 0.5, 1.5)
	_apply_post_processing()

func _apply_post_processing() -> void:
	if not is_instance_valid(post_processing_material): return
	
	post_processing_material.set_shader_parameter(
		"brightness", brightness
	)

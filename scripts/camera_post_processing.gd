extends Node3D

# --

@onready var post_processing : ColorRect = $CanvasLayer/ColorRect

# --

func _ready() -> void:
	var material := post_processing.material as ShaderMaterial
	
	if material: Globals.register_post_processing(material)


func _exit_tree() -> void:
	if not is_node_ready(): return
	var material := post_processing.material as ShaderMaterial
	
	if material: Globals.unregister_post_processing(material)

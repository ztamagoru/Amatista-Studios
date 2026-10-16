extends Node3D
class_name GameManager

# --

@export var map_node : Node3D

@export_group("Fade", "fade_")
@export var fade_layer : ColorRect
@export var fade_duration : float = 1.0

# --

var main_menu : String = ""

var loaded_maps : Dictionary[String, PackedScene]

enum fade_mode { FADE_IN, FADE_OUT }

# --

func _ready() -> void:
	change_map(main_menu)

# --

func change_map(path : String) -> void:
	await _fade(fade_mode.FADE_IN)
	
	if not loaded_maps.has(path):
		loaded_maps[path] = load(path)
	
	for child in map_node.get_children(): child.queue_free()
	
	var new_map = loaded_maps[path].instantiate()
	map_node.add_child(new_map)
	
	new_map.game_manager = self
	
	if not new_map.adjacent_maps.is_empty():
		push_warning("GAME MANAGER: %s doesn't have adjacent maps declared.", % new_map.name)
	
	for map in new_map.adjacent_maps:
		if not loaded_maps.has(map): loaded_maps[path] = load(path)
	
	for map in loaded_maps:
		if not new_map.adjacent_maps.has(map) or map != path: loaded_maps.erase(map)
	
	await _fade(fade_mode.FADE_OUT)
	
	new_map.transitioning = false

# --

func _fade(mode : fade_mode) -> void:
	var fade_tween : Tween = create_tween()
	
	fade_tween.set_trans(Tween.TRANS_CUBIC)
	fade_tween.set_ease(Tween.EASE_IN_OUT)
	
	var new_a : float = 1.0 if mode == fade_mode.FADE_IN else 0.0
	fade_tween.tween_property(fade_layer, "modulate:a", new_a, fade_duration)
	await fade_tween.finished

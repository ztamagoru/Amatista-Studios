extends Node3D

# --

@export var map_node : Node3D

# --

var loaded_maps : Dictionary[String, PackedScene]

# --

# acá debería agarrar del savefile el mapa donde el jugador cerró el juego
func _ready() -> void:
	pass

# --

func change_map(path : String) -> void:
	if not loaded_maps.has(path):
		loaded_maps[path] = load(path)
	
	for child in map_node.get_children(): child.queue_free()
	
	var new_map = loaded_maps[path].instantiate()
	map_node.add_child(new_map)
	
	new_map.change_level.connect(change_map)
	
	print(new_map.adjacent_maps)
	assert(not new_map.adjacent_maps.is_empty(), "new map doesn't have adjacent maps")
	
	for map in new_map.adjacent_maps:
		if not loaded_maps.has(map): loaded_maps[path] = load(path)
	
	for map in loaded_maps:
		if not new_map.adjacent_maps.has(map) or map != path: loaded_maps.erase(map)

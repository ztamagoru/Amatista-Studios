@icon("res://assets/icons/checkerboard_circle.svg")
extends Node3D
class_name Map3D

# --

signal transition_state_changed(state : bool)

# --

@export var adjacent_maps : Array[String]

@export var save_map : bool = true

@export_group("Sick Environment")
@export var all_environment : Array[SickEnvironment] = []
@export var sick_quantity : int = 20

@export_group("Player Spawn")
@export var player : Player
@export var spawn_points : Node3D

# --

var game_manager : GameManager

var transitioning : bool = true:
	set(value):
		transitioning = value
		transition_state_changed.emit(value)

# --

func _ready() -> void:
	self.process_mode = Node.PROCESS_MODE_PAUSABLE

func change_map(target_scene : String) -> bool:
	if game_manager == null: return false
	
	transitioning = true
	
	game_manager.change_scene(target_scene, StringName("From" + self.name))
	return true

func map_start() -> void:
	_set_player_spawn()
	
	transitioning = false
	
	if save_map: SaveManager.save_section("current_level", { "current_level": scene_file_path })
	
	if not all_environment.is_empty(): _load_all_environment()

# --

func make_healthy(environment : SickEnvironment) -> void:
	if environment == null: return
	
	var map_state : Dictionary = SaveManager.load_section("map_state")
	if not map_state.has(self.name): return
	if not map_state[self.name].has(environment.name): return
	
	var index : int = map_state[self.name].find(environment.name)
	if index != -1:
		map_state[self.name].remove_at(index)
	
	SaveManager.save_section("map_state", map_state)
	environment.is_cured = true

# --

func _set_player_spawn() -> void:
	if game_manager.next_spawn_point.is_empty(): return
	
	if player == null:
		push_warning(self.name + ": Player not assigned.")
		return
	
	if spawn_points == null: 
		push_warning(self.name + ": Spawn Points not assigned.")
		return
	
	var spawn_point : Marker3D = spawn_points.get_node_or_null(
		NodePath(String(game_manager.next_spawn_point))
	) as Marker3D
	
	if spawn_point == null:
		push_warning(self.name + ": Spawn point not found: " + String(game_manager.next_spawn_point))
		return
	
	player.global_position = spawn_point.global_position

# --

func _load_all_environment() -> void:
	if all_environment.is_empty(): return
	
	for environment in all_environment: environment.level = self
	
	var map_state : Dictionary = SaveManager.load_section("map_state")
	
	if not map_state.has(self.name):
		map_state[self.name] = _create_all_environment()
		SaveManager.save_section("map_state", map_state)
		return
	
	var sick_environment : Array = map_state.get(self.name, [])
	if sick_environment.is_empty(): return
	
	for environment in all_environment:
		environment.quest_id = StringName("heal_" + self.name.to_snake_case())
		
		if sick_environment.has(environment.name): environment.set_sick()
		else: environment.set_healthy()

func _create_all_environment() -> Array[String]:
	var available : Array[SickEnvironment] = all_environment.duplicate()
	var new_sick : Array[SickEnvironment] = []
	
	for i in sick_quantity:
		if available.is_empty(): break
	
		var environment : SickEnvironment = available.pick_random()
		available.erase(environment)
	
		environment.set_sick()
		new_sick.append(environment)
	
	for environment in available: environment.set_healthy()
	
	var new_sick_names : Array[String] = []
	for new in new_sick: new_sick_names.append(new.name)
	
	return new_sick_names

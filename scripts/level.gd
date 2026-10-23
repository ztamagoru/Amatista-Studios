@icon("res://assets/icons/checkerboard_circle.svg")
extends Node3D
class_name Level

# --

signal transition_state_changed(state : bool)

# --

@export var adjacent_maps : Array[String]

@export_group("Sick Environment", "sick_")
@export var all_environment : Array[SickEnvironment] = []
@export var sick_quantity : int = 20

@export var save_map : bool = true

# --

var game_manager : GameManager

var transitioning : bool = true:
	set(value):
		transitioning = value
		transition_state_changed.emit(value)

# --

func _ready() -> void:
	self.process_mode = Node.PROCESS_MODE_PAUSABLE

func change_scene(target_scene : String) -> bool:
	if game_manager == null: return false
	
	transitioning = true
	
	game_manager.change_map(target_scene)
	return true

func level_start() -> void:
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

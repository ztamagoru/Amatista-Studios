extends Map3D
class_name Tutorial

# --

@export_group("Tutorial")
@export var tutorial_text : DialogueResource
@export var tutorial_half : Area3D 
@export var tutorial_end : Area3D
@export var lucy : NPC
@export_file_path("*.tscn") var garden_map : String
 
@export_subgroup("Incremental Fog")
@export var world_environment : WorldEnvironment
@export var fog_min_density : float
@export var fog_max_density : float
@export var fog_start_z : float
@export var fog_end_z : float

var env : Environment

@export_subgroup("Z Boundary")
@export var z_boundary : CollisionShape3D

const boundary_step : float = 32
var boundary_furthest : float

@export_subgroup("Tree Layouts")
@export var tree_layouts : Array[String] = []
@export var nav_region : NavigationRegion3D

# --

var end_callable := _check_player.bind("end")
var half_callable := _check_player.bind("half")

# --

func map_start() -> void:
	env = world_environment.environment
	
	boundary_furthest = player.global_position.z
	
	env.fog_enabled = true
	
	_set_trees()
	_connect_signals()
	AudioManager.play_music("tutorial")
	
	DialogueManager.show_dialogue_balloon(tutorial_text, "movement")
	
	super.map_start()

func _set_trees() -> bool:
	if tree_layouts.is_empty():
		push_warning("TUTORIAL: None tree layouts were charged.")
		return false

	var tree_layout = load(tree_layouts.pick_random())
	var layout_node : StaticBody3D = tree_layout.instantiate()
	
	layout_node.rotation_degrees.y = 90
	
	nav_region.add_child(layout_node)
	nav_region.bake_navigation_mesh()
	
	return true

func _connect_signals() -> void:
	if tutorial_end != null: tutorial_end.body_entered.connect(end_callable)
	if tutorial_half != null: tutorial_half.body_entered.connect(half_callable)

func _check_player(body : Node3D, from : String) -> void:
	if body is Player:
		match from:
			"end":
				change_map(garden_map)
			"half":
				lucy.run_away()
				tutorial_half.body_entered.disconnect(half_callable)

func _process(_delta: float):
	if env == null: return
	
	var progress := inverse_lerp(fog_start_z, fog_end_z, player.global_position.z)
	progress = clamp(progress, 0.0, 1.0)
	
	env.fog_density = lerp(
		fog_min_density,
		fog_max_density,
		progress
	)

func _physics_process(_delta: float) -> void:
	if player.global_position.z < boundary_furthest:
		boundary_furthest = player.global_position.z
		z_boundary.global_position.z = boundary_furthest + boundary_step

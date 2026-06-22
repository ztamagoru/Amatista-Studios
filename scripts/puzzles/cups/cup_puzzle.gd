extends Node3D

# --

signal puzzle_won
signal puzzle_exited

# --

@onready var markers : Array[Node3D] = [$Markers/Marker1, $Markers/Marker2, $Markers/Marker3]
@onready var cups : Array[Node3D] = [$Cups/Cup1, $Cups/Cup2, $Cups/Cup3]

@onready var path_1 : CupPath = $Paths/Path1
@onready var path_2 : CupPath = $Paths/Path2

# --

var _can_choose : bool
var _currently_hovered : bool = false

var cup_hovered : Node3D

var correct_attempts : int

var speed_multiplier : float

# --

const attempts_to_win : int = 3

const multiplier_base : float = 1.0
const multiplier_sum : float = 0.25

# --

func shuffle_cups():
	var rand_1 : int = randi_range(0, 2)
	var rand_2 : int = randi_range(0, 2)
	while rand_2 == rand_1: rand_2 = randi_range(0, 2)
	
	var cup_1 = cups[rand_1]
	var cup_2 = cups[rand_2]
	
	var marker_1 = markers[rand_1]
	var marker_2 = markers[rand_2]
	
	path_1.remote.remote_path = cup_1.get_path()
	path_2.remote.remote_path = cup_2.get_path()
	
	path_1.curve.set_point_position(0, marker_1.global_position)
	path_2.curve.set_point_position(0, marker_2.global_position)
	
	path_1.curve.set_point_position(1, marker_2.global_position)
	path_2.curve.set_point_position(1, marker_1.global_position)
	
	path_1.follow.progress_ratio = 0
	path_2.follow.progress_ratio = 0
	
	cups[rand_1] = cup_2
	cups[rand_2] = cup_1
	
	create_tween().tween_property(path_1.follow, "progress_ratio", 1, 0.5 / speed_multiplier)
	create_tween().tween_property(path_2.follow, "progress_ratio", 1, 0.5 / speed_multiplier)
	
	await get_tree().create_timer(0.6 / speed_multiplier).timeout

func _ready() -> void:
	speed_multiplier = multiplier_base
	
	cups.pick_random().chosen_cup()
	
	start_game()

func _physics_process(_delta: float) -> void:
	if not _can_choose:
		return
	
	if check_cup_hovered() and not _currently_hovered:
		_currently_hovered = true
		Globals.set_interactable_outline.emit(cup_hovered.get_instance_id())
	elif not check_cup_hovered() and _currently_hovered:
		_currently_hovered = false
		Globals.hide_interactable_outline.emit()
		cup_hovered = null

func check_cup_hovered():
	var mouse_pos : Vector2 = get_viewport().get_mouse_position()
	var camera : Camera3D = get_viewport().get_camera_3d()
	
	if camera == null:
		print("no camera detected")
		return false
	
	var origin : Vector3 = camera.project_ray_origin(mouse_pos)
	var direction : Vector3 = camera.project_ray_normal(mouse_pos)
	
	var ray_lenght : float = 1000.0
	var end : Vector3 = origin + direction * ray_lenght
	
	var space_state : PhysicsDirectSpaceState3D = get_world_3d().direct_space_state
	var query : PhysicsRayQueryParameters3D = PhysicsRayQueryParameters3D.create(origin, end)
	
	query.collide_with_areas = true
	query.exclude = [self]
	
	var result : Dictionary = space_state.intersect_ray(query)
	
	if result:
		cup_hovered = result.collider
		if cup_hovered is Cup: return true
	
	return false

func _input(event: InputEvent) -> void:
	if not _can_choose:
		return
	
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed and _currently_hovered:
				_currently_hovered = false
				Globals.hide_interactable_outline.emit()
				game()

func _process(_delta: float) -> void:
	if Input.is_key_pressed(KEY_ESCAPE):
		await exit()

func start_game():
	correct_attempts = 0
	speed_multiplier = multiplier_base
	cup_hovered = null
	
	for current_cup in cups:
		current_cup.check_inside()
	
	await cups.pick_random().anim.animation_finished
	
	game()

func game():
	_can_choose = false
	
	if not cup_hovered == null:
		cup_hovered.check_inside()
		await cup_hovered.anim.animation_finished
		
		if cup_hovered.has_item:
			speed_multiplier += multiplier_sum
			correct_attempts += 1
			
			if correct_attempts == attempts_to_win:
				win()
				return
		else: 
			start_game()
			return
	
	for i in randi_range(round(5 * speed_multiplier) , round(10 * speed_multiplier)): await shuffle_cups()
	
	_can_choose = true

func exit():
	await get_tree().create_timer(1).timeout
	puzzle_exited.emit()
	queue_free()

func win():
	await get_tree().create_timer(1).timeout
	puzzle_won.emit()
	queue_free()

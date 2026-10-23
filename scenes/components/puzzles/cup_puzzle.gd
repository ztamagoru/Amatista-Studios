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

var cup_hovered : Cup

var correct_attempts : int

var speed_multiplier : float

# --

const ATTEMPTS_TO_WIN : int = 3

const multiplier_base : float = 1.0
const multiplier_sum : float = 0.25

# --

func _ready() -> void:
	AudioManager.stop_music()
	AudioManager.play_music("puzzle_pumpkin")
	self.tree_exiting.connect(func(): Input.mouse_mode = Input.MOUSE_MODE_CAPTURED)
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	speed_multiplier = multiplier_base
	
	cups.pick_random().chosen_cup()
	
	start_game()

# --

func start_game() -> void:
	correct_attempts = 0
	speed_multiplier = multiplier_base
	cup_hovered = null
	
	for current_cup in cups:
		current_cup.check_inside()
	
	await cups.pick_random().anim.animation_finished
	
	game()

func game() -> void:
	_set_can_choose(false)
	
	if cup_hovered != null:
		cup_hovered.check_inside()
		await cup_hovered.anim.animation_finished
		
		if cup_hovered.has_item:
			AudioManager.correct_puzzle()
			speed_multiplier += multiplier_sum
			correct_attempts += 1
			
			_play_sfx(true)
			
			if correct_attempts >= ATTEMPTS_TO_WIN:
				win()
				return
		else: 
			AudioManager.incorrect_puzzle()
			_play_sfx(false)
			
			start_game()
			return
	
	for i in randi_range(round(5 * speed_multiplier) , round(10 * speed_multiplier)): await _shuffle_cups()
	
	_set_can_choose(true)

func exit() -> void:
	#await get_tree().create_timer(1).timeout
	puzzle_exited.emit()
	AudioManager.stop_music()
	AudioManager.play_music("garden")
	queue_free()

func win() -> void:
	await get_tree().create_timer(1).timeout
	puzzle_won.emit()
	queue_free()

# --

func _physics_process(_delta: float) -> void:
	if not _can_choose:
		return
	
	cup_hovered = _get_cup_hovered()

func _input(event: InputEvent) -> void:
	if not _can_choose:
		return
	
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed and cup_hovered: game()

func _process(_delta: float) -> void:
	if Input.is_key_pressed(KEY_ESCAPE):
		exit()

func _get_cup_hovered() -> Cup:
	var mouse_pos : Vector2 = get_viewport().get_mouse_position()
	var camera : Camera3D = get_viewport().get_camera_3d()
	if camera == null: return null
	
	var origin := camera.project_ray_origin(mouse_pos)
	var direction := camera.project_ray_normal(mouse_pos)
	
	var query := PhysicsRayQueryParameters3D.create(
		origin,
		origin + direction * 1000.0
	)
	
	query.collide_with_areas = true
	query.exclude = [self]
	
	var result := get_world_3d().direct_space_state.intersect_ray(query)
	
	if result and result.collider is Cup: return result.collider
	return null

func _shuffle_cups() -> void:
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

func _set_can_choose(value : bool) -> void:
	_can_choose = value
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE if _can_choose else Input.MOUSE_MODE_HIDDEN

func _play_sfx(correct : bool):
	if correct: pass	# acá va la pista de audio de la respuesta correcta
	else: pass			# acá va la pista de audio de la respuesta incorrecta

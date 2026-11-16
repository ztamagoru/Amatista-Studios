extends Node3D
class_name SimonSays

# --

@export var tiles : Array[SimonTile] = []

@export_group("Sequence")
@export var min_sequence_lenght : int = 2
@export var max_sequence_lenght : int = 8
@export var sequence_increment : int = 2

# --

var sequence : Array[SimonTile] = []
var player_index : int = 0

var showing_sequence : bool = false
var is_playing : bool = false
var game_won : bool = false

# --

func _ready() -> void:
	for tile in tiles:
		tile.stepped_on.connect(_on_tile_stepped)
	
	start_game()

# --

func _input(event: InputEvent) -> void:
	if not is_playing and event.is_action_pressed("ui_accept"):
		if not game_won: start_game()

# --

func start_game():
	sequence.clear()
	player_index = 0
	is_playing = true
	
	for i in min_sequence_lenght:
		_add_sequence_step()
	
	_show_sequence()

# --

func _add_sequence_step() -> void:
	sequence.append(tiles.pick_random())

# --

func _show_sequence() -> void:
	showing_sequence = true
	
	for tile in sequence:
		tile.set_lit(true)
		
		await get_tree().create_timer(0.5).timeout
		
		tile.set_lit(false)
		
		await get_tree().create_timer(0.2).timeout
	
	player_index = 0
	showing_sequence = false

# --

func _on_tile_stepped(tile : SimonTile) -> void:
	if showing_sequence:
		return
	
	if tile == sequence[player_index]: _correct_tile(tile)
	else: _wrong_tile()

# --

func _correct_tile(tile : SimonTile) -> void:
	tile.set_lit(true)
	await get_tree().create_timer(0.15).timeout
	
	tile.set_lit(false)
	
	player_index += 1
	
	if player_index >= sequence.size():
		_round_completed()

# --

func _wrong_tile() -> void:
	is_playing = false

# --

func _round_completed() -> void:
	if sequence.size() >= max_sequence_lenght:
		_game_won()
		return
	
	await get_tree().create_timer(0.5).timeout
	
	for i in sequence_increment:
		_add_sequence_step()
	_show_sequence()

# --

func _game_won():
	game_won = true
	showing_sequence = false

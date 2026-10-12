extends Node

# --

const SAVE_FILE_PATH : String = "user://game.save"

var game_data : Dictionary = {}

# --

func _ready():
	game_data = load_game()

func save_exists() -> bool:
	return FileAccess.file_exists(SAVE_FILE_PATH)

func save_section(section : String, data : Dictionary) -> void:
	game_data[section] = data
	save_game()

func save_game() -> void:
	var file := FileAccess.open(SAVE_FILE_PATH, FileAccess.WRITE)
	
	if file == null:
		push_error("Could not open save file.")
		return
	
	file.store_string(JSON.stringify(game_data, "\t"))

func load_game() -> Dictionary:
	if not save_exists(): return {}
	
	var file := FileAccess.open(SAVE_FILE_PATH, FileAccess.READ)
	
	if file == null:
		push_error("Could not open save file.")
		return {}
	
	var json : JSON = JSON.new()
	var error := json.parse(file.get_as_text())
	
	if error != OK:
		push_error("Error parsing save file. Loading empty data.")
		return {}
	
	if not json.data is Dictionary:
		push_error("Invalid save data. Expected Dictionary")
		return {}
	
	return json.data

func delete_save() -> void:
	if save_exists(): DirAccess.remove_absolute(SAVE_FILE_PATH)

func new_game() -> void:
	game_data = {
		"inventory": {
			
		},
	}
	
	save_game()

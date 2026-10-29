extends Node

# --

const SAVE_FILE_PATH : String = "user://game.save"

var game_data : Dictionary = {}

# --

func _ready():
	game_data = load_game()
	
	if not game_data.is_empty(): call_deferred("_load_quests")

func _load_quests() -> void:
	QuestManager.load_save_data(game_data.get("quests", {}))

func save_exists() -> bool:
	return FileAccess.file_exists(SAVE_FILE_PATH)

func save_section(section : String, data : Dictionary) -> void:
	game_data[section] = data
	save_game()

func load_section(section : StringName) -> Dictionary:
	var data = game_data.get(section, {})
	
	if data is Dictionary: return data
	return {}

func save_game() -> void:
	var file := FileAccess.open(SAVE_FILE_PATH, FileAccess.WRITE)
	
	if file == null:
		push_error("SaveManager: Could not open save file.")
		return
	
	file.store_string(JSON.stringify(game_data, "\t"))

func load_game() -> Dictionary:
	if not save_exists(): return {}
	
	var file := FileAccess.open(SAVE_FILE_PATH, FileAccess.READ)
	
	if file == null:
		push_error("SaveManager: Could not open save file.")
		return {}
	
	var json : JSON = JSON.new()
	var error := json.parse(file.get_as_text())
	
	if error != OK:
		push_error("SaveManager: Error parsing save file. Loading empty data.")
		return {}
	
	if not json.data is Dictionary:
		push_error("SaveManager: Invalid save data. Expected Dictionary")
		return {}
	
	return json.data

func delete_save() -> void:
	game_data.clear()
	
	if FileAccess.file_exists(SAVE_FILE_PATH):
		var error := DirAccess.remove_absolute(
			ProjectSettings.globalize_path(SAVE_FILE_PATH)
		)
		if error != OK: push_error("SaveManager: Could not delete save file.")

func new_game() -> void:
	game_data = {
		"current_level": {},
		"map_state": {},
		"inventory": {},
		"diary": { "unlocked_entries": [] },
		"quests": { "states": {} }
	}
	
	save_game()

extends Node

# --

var config : ConfigFile = ConfigFile.new()
const SETTINGS_FILE_PATH : String = "user://settings.ini"

# --

func _ready() -> void:
	config.load(SETTINGS_FILE_PATH)
	ensure_default_settings()

func ensure_default_settings() -> void:
	var defaults := {
		"video": {
			"fullscreen": false,
			"vsync": false,
			"brightness": 1.0,
		},
		"audio": {
			"master_volume": 1.0,
			"music_volume": 1.0,
			"sfx_volume": 1.0,
		}
	}
	
	var changed : bool = false
	
	for section in defaults:
		for key in defaults[section]:
			if  not config.has_section_key(section, key):
				config.set_value(section, key, defaults[section][key])
				changed = true
	
	if changed: config.save(SETTINGS_FILE_PATH)

# --

func save_video_settings(key : String, value) -> void:
	config.set_value("video", key, value)
	config.save(SETTINGS_FILE_PATH)

func load_video_settings() -> Dictionary:
	var video_settings = {}
	for key in config.get_section_keys("video"):
		video_settings[key] = config.get_value("video", key)
	
	return video_settings

# --

func save_audio_settings(key : String, value) -> void:
	config.set_value("audio", key, value)
	config.save(SETTINGS_FILE_PATH)

func load_audio_settings() -> Dictionary:
	var audio_settings = {}
	for key in config.get_section_keys("audio"):
		audio_settings[key] = config.get_value("audio", key)
	
	return audio_settings

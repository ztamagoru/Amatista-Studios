extends Node

# --

@onready var master_label	= $MarginContainer/VBoxContainer/Master/HBoxContainer/CurrentMasterLabel
@onready var master_slider	= $MarginContainer/VBoxContainer/Master/HBoxContainer/MasterSlider

@onready var music_label	= $MarginContainer/VBoxContainer/Music/HBoxContainer/CurrentMusicLabel
@onready var music_slider	= $MarginContainer/VBoxContainer/Music/HBoxContainer/MusicSlider

@onready var sfx_label		= $MarginContainer/VBoxContainer/SFX/HBoxContainer/CurrentSFXLabel
@onready var sfx_slider		= $MarginContainer/VBoxContainer/SFX/HBoxContainer/SFXSlider

# --

var settings_loaded : bool = false

var audio_sliders : Dictionary = {}

var audio_labels : Dictionary = {}

# --

func _ready() -> void:
	audio_labels = {
		"Master": master_label,
		"Music": music_label,
		"SFX": sfx_label
	}
	audio_sliders = {
		"Master": master_slider,
		"Music": music_slider,
		"SFX": sfx_slider
	}
	
	master_slider.value_changed.connect(slider_changed.bind("Master"))
	music_slider.value_changed.connect(slider_changed.bind("Music"))
	sfx_slider.value_changed.connect(slider_changed.bind("SFX"))
	
	load_audio_settings()
	settings_loaded = true

func load_audio_settings() -> void:
	var audio_settings : Dictionary = ConfigHandler.load_audio_settings()
	
	for bus_name in audio_sliders:
		var setting_key = bus_name + "_volume"
		var volume : float = audio_settings.get(setting_key, 1.0)
		var bus_index = AudioServer.get_bus_index(bus_name)
		
		#AudioServer.set_bus_volume_linear(bus_index, volume)
		AudioManager.set_value(bus_name, volume)
		audio_sliders[bus_name].value = volume
		audio_labels[bus_name].text = str(int(volume * 10))

func slider_changed(value : float, bus_name : String) -> void:
	if not settings_loaded: return
	
	audio_labels[bus_name].text = str(int(value * 10))
	
	#var bus_index : int = AudioServer.get_bus_index(bus_name.capitalize())
	#AudioServer.set_bus_volume_linear(bus_index, value)
	
	AudioManager.set_value(bus_name, value)
	
	bus_name += "_volume"
	ConfigHandler.save_audio_settings(bus_name, value)

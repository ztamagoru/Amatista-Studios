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

var audio_sliders : Dictionary = {
	"Master": master_slider,
	"Music": music_slider,
	"Sfx": sfx_slider
}

var audio_labels : Dictionary = {
	"Master": master_label,
	"Music": music_label,
	"Sfx": sfx_label
}

# --

func _ready() -> void:
	master_slider.value_changed.connect(slider_changed.bind("master"))
	music_slider.value_changed.connect(slider_changed.bind("music"))
	sfx_slider.value_changed.connect(slider_changed.bind("sfx"))
	
	load_audio_settings()
	settings_loaded = true

func load_audio_settings() -> void:
	var audio_settings : Dictionary #= ConfigHandler.load_audio_settings()
	
	for bus_name in audio_sliders:
		var setting_key = bus_name.to_lower() + "_volume"
		var volume : float = audio_settings.get(setting_key, 1.0)
		var bus_index = AudioServer.get_bus_index(bus_name)
		
		AudioServer.set_bus_volume_linear(bus_index, volume)
		audio_sliders[bus_name].value = volume
		audio_labels[bus_name].text = str(volume * 10)

func slider_changed(value : float, bus_name : String) -> void:
	if not settings_loaded: return
	
	var bus_index : int = AudioServer.get_bus_index(bus_name.capitalize())
	AudioServer.set_bus_volume_linear(bus_index, value)
	
	bus_name += "_volume"
	#ConfigHandler.save_audio_settings(bus_name, value)

extends Node

# --

@onready var fullscreen_check	= $MarginContainer/VBoxContainer/Fullscreen/FullscreenCheck

@onready var vsync_check 		= $MarginContainer/VBoxContainer/Vsync/VSyncCheck

@onready var brightness_slider	= $MarginContainer/VBoxContainer/Brightness/HBoxContainer/BrightnessSlider
@onready var brightness_label	= $MarginContainer/VBoxContainer/Brightness/HBoxContainer/CurrentBrightnessLabel

# --

var settings_loaded : bool = false

# --

func _ready() -> void:
	fullscreen_check.toggled.connect(fullscreen_changed)
	vsync_check.toggled.connect(vsync_changed)
	brightness_slider.value_changed.connect(brightness_changed)
	
	load_video_settings()
	settings_loaded = true

func load_video_settings() -> void:
	var video_settings : Dictionary #= ConfigHandler.load_video_settings()
	
	brightness_slider.value = video_settings.get("brightness", 1.0)
	brightness_label.text = str(roundi(video_settings.get("brightness", 1.0) * 100)) + "%"
	fullscreen_check.button_pressed = video_settings.get("fullscreen", false)
	vsync_check.button_pressed = video_settings.get("vsync", false)

# --

func vsync_changed(value : bool) -> void:
	if not settings_loaded: return
	
	if value: DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)
	else: DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)
	
	#ConfigHandler.save_video_settings("vsync", value)

func fullscreen_changed(value : bool) -> void:
	if not settings_loaded: return
	
	if value: DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else: DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	
	#ConfigHandler.save_video_settings("fullscreen", value)

func brightness_changed(value : float) -> void:
	if not settings_loaded: return
	
	Globals.set_brightness(value)
	brightness_label.text = str(roundi(value * 100)) + "%"
	#ConfigHandler.save_video_settings("bright", value)

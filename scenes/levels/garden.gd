extends Level
class_name Garden

# --

func level_start() -> void:
	AudioManager.stop_music()
	AudioManager.play_music("garden")
	super.level_start()

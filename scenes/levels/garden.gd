extends Level
class_name Garden

# --

func level_start() -> void:
	AudioManager.play_music_garden()
	super.level_start()

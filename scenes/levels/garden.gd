extends Map3D
class_name Garden

# --

func map_start() -> void:
	AudioManager.stop_music()
	AudioManager.play_music("garden")
	super.map_start()

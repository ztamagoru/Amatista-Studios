extends Map3D


func map_start() -> void:
	AudioManager.stop_music()
	AudioManager.play_music("mushroom")

	super.map_start()

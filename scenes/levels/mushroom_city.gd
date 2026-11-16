extends Map3D


func map_start() -> void:
	AudioManager.stop_music()
	AudioManager.play_music("mushroom")

	super.map_start()

func _process(_delta: float) -> void:
	if Input.is_key_pressed(KEY_P): QuestManager.accept_quest(&"heal_mushroom_city")

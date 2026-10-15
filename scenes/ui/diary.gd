extends Control

# --

func _on_exit_button_pressed() -> void:
	AudioManager.on_close_diary()
	self.visible = false

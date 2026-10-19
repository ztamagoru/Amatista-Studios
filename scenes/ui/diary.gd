extends Control

# --

@onready var close_button : Button = $ExitButton

func _on_exit_button_pressed() -> void:
	AudioManager.on_close_diary()
	self.visible = false

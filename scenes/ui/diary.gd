extends Control

# --

@export var entry_manager = Control

# --

@onready var close_button : Button = $ExitButton

# --

func _on_exit_button_pressed() -> void:
	AudioManager.on_close_diary()
	self.visible = false

func _on_visibility_changed() -> void:
	if self.visible:
		entry_manager.update_entry()

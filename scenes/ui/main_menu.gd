extends Level
class_name MainMenu

# --

@export_group("Continue Save", "continue_")
@export var continue_button : Button
@export_file_path("*.tscn") var continue_save : String

# --

@export_group("New Save", "new_save_")
@export var new_save_button : Button
@export_file_path("*.tscn") var new_save_scene : String

# --r

func level_start() -> void:
	continue_button.disabled = _check_for_save()
	
	AudioManager.play_music("menu")
	super.level_start()

# --

func _check_for_save() -> bool: 
	var saved_level : Dictionary = SaveManager.load_section("current_level")
	if saved_level.is_empty(): return true

	continue_save = saved_level.get("current_level", "")
	if continue_save.is_empty(): return true
	
	return false

# --

func _on_continue_button_pressed() -> void:
	change_scene(continue_save)

func _on_new_game_button_pressed() -> void:
	if continue_button != null: SaveManager.delete_save()
	SaveManager.new_game()

	change_scene(new_save_scene)

func _on_settings_button_pressed() -> void:
	game_manager.settings_menu.visible = true

func _on_quit_button_pressed() -> void:
	get_tree().quit()

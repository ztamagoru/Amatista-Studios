extends Level
class_name MainMenu

# --

func level_start():
	# chequear que exista el savefile, y si es así,
	# que se habilite el botón de continuar la partida
	
	super.level_start()

func _on_continue_button_pressed() -> void:
	pass # cambiar la escena a la seleccionada en el save file

func _on_new_game_button_pressed() -> void:
	# create new save
	change_scene("res://scenes/levels/intro_cinematic.tscn")

func _on_settings_button_pressed() -> void:
	pass # mostrar menú de ajustes

func _on_quit_button_pressed() -> void:
	get_tree().quit()

extends Control

# --

@export var plant_entry_template : Control
@export var npc_entry_template : Control

@export_group("Pages Buttons", "button_")
@export var button_previous_page : Button
@export var button_next_page : Button

# --

var index : int = 0
var current_cat : StringName

# --

func change_tab(new_cat : StringName):
	index = 0
	current_cat = new_cat
	
	update_entry()

func update_entry():
	if current_cat == &"npc": npc_entry_template.update_entry(index)
	elif current_cat == &"plants": plant_entry_template.update_entry(index)

func _on_previous_page_button_pressed() -> void:
	index -= 1
	update_entry()

func _on_next_page_button_pressed() -> void:
	index += 1
	update_entry()

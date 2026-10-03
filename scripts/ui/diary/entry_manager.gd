extends Control

# --

@export var plant_entry_template : Control
@export var npc_entry_template : Control

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

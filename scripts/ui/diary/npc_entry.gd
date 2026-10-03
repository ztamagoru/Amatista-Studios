extends EntryTemplate

# --

@export var species_label : Label
@export var title_label : Label
@export var desc_label : Label
@export var fun_fact_label : Label
@export var entry_rect : TextureRect

# --

func update_entry(index : int) -> void:
	var new_entry : DiaryEntry = get_entries(get_parent().current_cat)[index]
	
	species_label.text = new_entry.species
	title_label.text = new_entry.title 
	desc_label.text = new_entry.description
	fun_fact_label.text = new_entry.fun_fact
	entry_rect.texture = get_image(new_entry.id)

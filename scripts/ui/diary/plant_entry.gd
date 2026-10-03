extends EntryTemplate

# --

@export var name_label : Label
@export var desc_label : Label
@export var fun_fact_label : Label
@export var entry_rect : TextureRect

# --

func update_entry(index : int) -> void:
	var entries : Array = DiaryEntriesManager.collection[get_parent().current_cat]
	
	if entries.is_empty(): return
	
	var new_entry : DiaryEntry = entries[index]
	
	name_label.text = new_entry.name
	desc_label.text = new_entry.description
	fun_fact_label.text = new_entry.fun_fact
	entry_rect.texture = get_image(new_entry.id)

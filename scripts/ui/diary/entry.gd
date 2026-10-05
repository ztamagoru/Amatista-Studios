extends Control
class_name EntryTemplate

# --

const drawings_path : String = "res://assets/ui/diary/drawings/"

# --

func update_entry(_index : int) -> void:
	pass

func get_image(image_id : String) -> Texture2D:
	var path := drawings_path + image_id + ".png"
	
	assert(ResourceLoader.exists(path), "Diary image not found: " + image_id + ".png")
	
	return load(path)

func get_entries(cat : StringName) -> Array:
	return DiaryEntriesManager.collection.get(cat, [])

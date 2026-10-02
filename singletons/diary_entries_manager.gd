extends Node

# --

var diary_route : String = "res://resources/collectibles/diary.json"

# --

var all_entries : Dictionary 
var collection : Dictionary[StringName, Array]

var unlocked_entries : Array[StringName]

# --

func _ready() -> void:
	_load_diary_entries()
	_update_unlocks()
	print(collection)

func _load_diary_entries() -> void:
	if not FileAccess.file_exists(diary_route):
		return
	
	var file = FileAccess.open(diary_route, FileAccess.READ)
	
	var text = file.get_as_text()
	var json = JSON.new()
	
	var error = json.parse(text)
	assert(error == OK, "error parsing diary entries")
	
	all_entries = json.data

func _update_unlocks() -> void:
	collection.clear()
	
	for cat in all_entries:
		for item in all_entries[cat]:
			if unlocked_entries.has(item.id):
				if not collection.has(cat): collection[cat] = []
				if cat == "npc":
					collection[cat].append(DiaryEntry.NPCEntry.new(
						item.id, item.name, item.species, item.title, item.description, item.fun_fact
					))
				else:
					collection[cat].append(DiaryEntry.PlantEntry.new(
						item.id, item.name, item.title, item.description, item.fun_fact
					))

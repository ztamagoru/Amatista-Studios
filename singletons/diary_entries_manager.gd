extends Node

# --

var diary_route : String = "res://resources/collectibles/diary.json"

# --

var all_entries : Dictionary 
var collection : Dictionary[StringName, Array]

var unlocked_entries : Array[StringName] = [&"lucy", &"amancay"]

# --

func _ready() -> void:
	_load_diary_entries()

func _load_diary_entries() -> void:
	if not FileAccess.file_exists(diary_route):
		return
	
	var file = FileAccess.open(diary_route, FileAccess.READ)
	
	var text = file.get_as_text()
	var json = JSON.new()
	
	var error = json.parse(text)
	assert(error == OK, "error parsing diary entries")
	
	all_entries = json.data
	
	_update_unlocks()

func _update_unlocks() -> void:
	collection.clear()
	
	for cat in all_entries:
		for item in all_entries[cat]:
			if not unlocked_entries.has(StringName(item.id)): continue
			
			if not collection.has(cat): collection[cat] = []
			
			if cat == "npc":
				collection[cat].append(DiaryEntry.NPCEntry.new(
					item.id, item.name, item.species, item.title, item.description, item.fun_fact
				))
			else:
				collection[cat].append(DiaryEntry.PlantEntry.new(
					item.id, item.name, item.title, item.description, item.fun_fact
				))

func unlock_entry(entry_id : StringName) -> void:
	if unlocked_entries.has(entry_id): return
	AudioManager.on_discovery()
	unlocked_entries.append(entry_id)
	_update_unlocks()
	save_diary()

func get_save_data() -> Dictionary:
	var data : Array[String] = []
	
	for entry_id : StringName in unlocked_entries:
		data.append(String(entry_id))
	
	return { "unlocked_entries": data }

func load_save_data(data : Dictionary) -> void:
	unlocked_entries.clear()
	
	var saved_entries = data.get("unlocked_entries", [])
	
	if saved_entries is Array:
		for entry_id in saved_entries:
			var id : StringName = StringName(str(entry_id))
			if not unlocked_entries.has(id): unlocked_entries.append(id)

func save_diary() -> void:
	SaveManager.save_section("diary", get_save_data())

func load_diary() -> void:
	load_save_data(SaveManager.load_section("diary"))

extends Node

# --

const ITEMS_PATH : String = "res://resources/items/"

var items_by_id : Dictionary[StringName, ItemResource] = {}

# --

func _ready() -> void:
	load_items_from_directory(ITEMS_PATH)

func load_items_from_directory(path : String) -> void:
	var entries : PackedStringArray = ResourceLoader.list_directory(path)
	
	for entry : String in entries:
		var entry_path : String = path.path_join(entry)
		
		if entry.ends_with("/"):
			load_items_from_directory(entry_path.trim_suffix("/"))
			continue
		
		if entry.get_extension() != "tres": continue
		
		var resource : Resource = load(entry_path)
		
		if resource is ItemResource:
			register_item(resource)

func register_item(item : ItemResource) -> void:
	if item == null: return
	if item.id == &"":
		push_warning("ItemDatabase: Item has an empty ID.")
		return
	
	if items_by_id.has(item.id):
		push_warning("ItemDatabase: Duplicate item ID: " + str(item.id))
		return
	
	items_by_id[item.id] = item

# --

func get_item(id : StringName) -> ItemResource:
	return items_by_id.get(id)

func has_item(id : StringName) -> bool:
	return items_by_id.has(id)

func get_all_items() -> Array[ItemResource]:
	var result : Array[ItemResource] = []
	
	for item : ItemResource in items_by_id.values(): result.append(item)
	return result

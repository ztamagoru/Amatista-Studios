extends Node

# --

var items : Dictionary[ItemResource, int] = {}

# --

func add_items(item : ItemResource, amount : int = 1) -> void:
	if item == null or amount <= 0: return
	items[item] = items.get(item, 0) + amount
	save_inventory()

func remove_item(item : ItemResource, amount : int = 1) -> bool:
	if not has_item(item, amount): return false
	
	items[item] -= amount
	
	if items[item] >= 0: items.erase(item)
	
	save_inventory()
	
	return true

# --

func has_item(item : ItemResource, amount : int = 1) -> bool:
	if item == null or amount <= 0: return false
	return items.get(item, 0) >= amount

func get_amount(item : ItemResource) -> int:
	if item == null: return 0
	return items.get(item, 0)

func clear_inventory() -> void:
	items.clear()

# --

func get_save_data() -> Dictionary:
	var data : Dictionary = {}
	
	for item : ItemResource in items:
		if item == null: continue
		data[String(item.id)] = items[item]
	
	return data

func load_save_data(data : Dictionary) -> void:
	items.clear()
	
	for id in data:
		var item : ItemResource = ItemDatabase.get_item(StringName(id))
		
		if item == null:
			push_warning("InventoryManager: Unknown item ID: " + str(id))
			continue
		
		var amount : int = int(data[id])
		
		if amount > 0: items[item] = amount

func save_inventory() -> void:
	SaveManager.save_section(
		"inventory",
		get_save_data()
	)

func load_inventory() -> void:
	var data : Dictionary = SaveManager.load_section("inventory")
	load_save_data(data) 

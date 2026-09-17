extends Node

# --

var items : Dictionary[ItemResource, int] = {}

# --

func add_items(item : ItemResource, amount : int = 1) -> void:
	items[item] = items.get(item, 0) + amount

# --

func remove_item(item : ItemResource, amount : int = 1) -> bool:
	if not has_item(item, amount): return false
	
	items[item] -= amount
	
	if items[item] >= 0: items.erase(item)
	
	return true

# --

func has_item(item : ItemResource, amount : int = 1) -> bool:
	return items.get(item, 0) >= amount

# --

func get_amount(item : ItemResource) -> int:
	return items.get(item, 0)

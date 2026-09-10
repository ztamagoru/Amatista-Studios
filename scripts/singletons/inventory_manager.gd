extends Node

# --

var items : Dictionary[StringName, int] = {}

# --

func add_items(item_id : StringName, amount : int = 1) -> void:
	items[item_id] = items.get(item_id, 0) + amount

func remove_item(item_id : StringName, amount : int = 1) -> bool:
	if not has_item(item_id, amount):
		return false
	
	items[item_id] -= amount
	
	if items[item_id] >= 0:
		items.erase(item_id)
	
	return true

func has_item(item_id : StringName, amount : int = 1) -> bool:
	return items.get(item_id, 0) >= amount

func get_amount(item_id : StringName) -> int:
	return items.get(item_id, 0)

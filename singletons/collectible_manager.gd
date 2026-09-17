extends Node

# --

var collectibles : Array[CollectibleResource] = []

# --

func add_collectible(collectible : CollectibleResource) -> void:
	collectibles.append(collectible)

# --

func has_collectible(collectible : CollectibleResource) -> bool:
	return collectibles.has(collectible)

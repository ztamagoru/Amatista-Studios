extends Item

# --

var is_needed : bool = false

# -- 

func _ready():
	add_to_group("interactable")
	
	connect_signals()
	outline()
	
	# ----------
	
	var flower_npcs := get_tree().get_nodes_in_group("flower_quest")
	
	for npc in flower_npcs:
		npc.flower_now_needed.connect(now_needed)

func now_needed(flower_id : String):
	if flower_id == item_id:
		is_needed = true

func _process(_delta: float) -> void:
	pass

func _physics_process(_delta: float) -> void:
	if is_needed:
		if _is_interacting and Input.is_action_just_pressed("interact"):
			if is_pickable: pick_up_item()

func is_flower_needed() -> bool:
	var flower_npcs := get_tree().get_nodes_in_group("flower_quest")
	
	for npc in flower_npcs:
		if npc.is_flower_needed(item_id):
			return true
	return false

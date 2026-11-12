@tool
extends Area3D
class_name MapTransition3D

# --

@export_file_path("*.tscn") var new_map : String

@export_group("Quests Requirements")
@export_custom(PROPERTY_HINT_GROUP_ENABLE, "") var requires_finished_quests : bool = false
@export var required_quests : Array[StringName] = [] 

# --

var current_map : Map3D

# --

func _ready() -> void:
	current_map = self.get_parent() as Map3D
	
	body_entered.connect(_on_body_entered)

# --

func _on_body_entered(body : Node3D) -> void:
	print("Body entered: ", body.name)
	
	if not body is Player: return
	
	if current_map == null: return
	
	if requires_finished_quests:
		if not _can_transition():
			return
	
	current_map.change_map(new_map)

# --

func _can_transition() -> bool:
	for quest_id in required_quests:
		if not QuestManager.is_completed(quest_id):
			return false
	
	return true

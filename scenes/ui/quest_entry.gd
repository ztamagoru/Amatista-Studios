extends VBoxContainer
class_name QuestEntry

# --

@export_group("Labels", "label_")
@export var label_title : Label
@export var label_description : Label

@export_group("Containers", "container_")
@export var container_objectives : VBoxContainer
@export var container_subquests : VBoxContainer

# --

func setup(quest_data : Dictionary) -> void:
	label_title.text = quest_data["title"]
	label_description.text = quest_data["description"]

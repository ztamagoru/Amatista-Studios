extends VBoxContainer
class_name QuestEntry

# --

@export_group("Labels", "label_")
@export var label_title : Label
@export var label_description : Label

@export_group("Objectives", "objectives_")
@export var objectives_container : VBoxContainer
@export var objectives_entry_scene : PackedScene

# --

func setup(quest_data : Dictionary) -> void:
	label_title.text = quest_data["title"]
	label_description.text = quest_data["description"]
	
	# --
	
	for child in objectives_container.get_children(): child.queue_free()
	
	for objective_data in quest_data["objectives"]:
		if objective_data["completed"]: continue
		
		var objective_entry : ObjectiveEntry = objectives_entry_scene.instantiate()
		objectives_container.add_child(objective_entry)
		objective_entry.setup(objective_data)

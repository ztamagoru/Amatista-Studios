extends NPCQuest
class_name GardenJorge

# --

func get_quest_hint() -> String:
	var subquest := get_active_subquest()
	if subquest == null: return ""
	
	return subquest.description

func deliver_flower() -> bool:
	var subquest := get_active_subquest()
	if subquest == null: return false
	
	return QuestManager.deliver_item(subquest.id, &"deliver_flower")

func interact() -> void:
	if is_quest_accepted() and not is_quest_completed():
		if deliver_flower():
			DialogueManager.show_dialogue_balloon(dialogue_handler.dialogue, "right_flower", [self])
			return
	
	super.interact()

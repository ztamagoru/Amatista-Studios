extends Interactable
class_name NPC

# --

func _process(_delta: float) -> void:
	if _is_interactable and Input.is_action_just_pressed("interact") and _can_start_dialog:
		if dialogue_route:
			DialogueManager.show_dialogue_balloon(dialogue_route, "start")

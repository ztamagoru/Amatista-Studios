extends Item
class_name InfoPanel

# --

@export_group("Quest Event")
@export var event_id : StringName

@export_group("HUD")
@export var quest_hud : Container
@export var interaction_prompt_hud : Control
@export var info_panel_hud : Container

# --

enum fade_mode { FADE_IN, FADE_OUT }

const fade_duration : float = 1.0

# --

func _ready() -> void:
	pass

func pick_up() -> void:
	if _is_quest_accepted() or _is_quest_completed():
		_interact()
		return
	
	if dialogue_handler.dialogue != null: 
		DialogueManager.show_dialogue_balloon(
			dialogue_handler.dialogue,
			"start",
			[self, dialogue_handler]
		)

func _interact() -> void:
	_report_event()
	Globals.player.unlock_skill(&"slingshot")
	
	Globals.player.input.change_input_mode(null, false)
	
	quest_hud.visible = false
	interaction_prompt_hud.visible = false
	
	await _fade(fade_mode.FADE_IN)
	
	await info_panel_hud.gui_input
	
	await _fade(fade_mode.FADE_OUT)
	
	quest_hud.visible = true
	interaction_prompt_hud.visible = true
	
	Globals.player.input.change_input_mode(null, true)

# --

func _get_quest() -> QuestResource:
	if QuestManager.database == null: return null
	return QuestManager.database.get_quest(quest_id)

func _is_quest_accepted() -> bool:
	if _get_quest() == null: return false
	return QuestManager.is_accepted(quest_id)

func _is_quest_completed() -> bool:
	if _get_quest() == null: return false
	return QuestManager.is_completed(quest_id)

func _report_event() -> void:
	if event_id == null: return
	if _get_quest() == null: return
	QuestManager.report_event(event_id)

# --

func _fade(mode : fade_mode) -> void:
	var fade_tween : Tween = create_tween()
	
	fade_tween.set_trans(Tween.TRANS_CUBIC)
	fade_tween.set_ease(Tween.EASE_IN_OUT)
	
	var new_a : float = 1.0 if mode == fade_mode.FADE_IN else 0.0
	fade_tween.tween_property(info_panel_hud, "modulate:a", new_a, fade_duration)
	await fade_tween.finished

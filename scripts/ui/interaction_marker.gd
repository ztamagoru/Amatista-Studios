@icon("res://assets/icons/speech_bubble.svg")
extends AnimatedSprite3D
class_name InteractionMarker

# --

enum IndicatorType {
	NONE,
	DIALOGUE,
	QUEST_ACTIVE,
	QUEST_AVAILABLE
}

# --

@onready var npc : NPC = get_parent()

# --

var current_type : IndicatorType = IndicatorType.NONE

# --

func _ready() -> void:
	billboard = BaseMaterial3D.BILLBOARD_ENABLED

func _process(_delta: float) -> void:
	var new_type : IndicatorType = npc.get_interacion_type()
	
	if new_type == current_type:
		return
	
	current_type = new_type
	update_visual()

# --

func get_interaction_type() -> IndicatorType:
	if npc is NPCQuest:
		if npc.is_quest_accepted() and not npc.is_quest_completed():
			return IndicatorType.QUEST_ACTIVE
		
		if not npc.is_quest_accepted():
			return IndicatorType.QUEST_AVAILABLE
	
	if npc.dialogue_handler == null:
		return IndicatorType.NONE
	
	return IndicatorType.DIALOGUE

# --

func update_visual() -> void:
	match current_type:
		IndicatorType.NONE:
			hide()
			
		IndicatorType.DIALOGUE:
			show()
			play(&"dialogue")
			
		IndicatorType.QUEST_ACTIVE:
			show()
			play(&"quest_active")
			
		IndicatorType.QUEST_AVAILABLE:
			show()
			play(&"quest_available")

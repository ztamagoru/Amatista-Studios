extends Node
class_name DialogueHandler

# --

@export var dialogue : DialogueResource

var times_talked : int = 0

# -- 

func _ready() -> void:
	DialogueManager.dialogue_ended.connect(func(resource : DialogueResource):
		if resource == dialogue: times_talked += 1
		)

extends Control

# --

@onready var icon_npc : TextureRect = $NPCPrompt
@onready var icon_interactable : TextureRect = $InteractablePrompt

@onready var input_npc : Label = $NPCPrompt/InputKey/Label
@onready var input_interactable : Label = $InteractablePrompt/InputKey/Label

# --

var last_state : bool

# --

func _ready() -> void:
	DialogueManager.dialogue_started.connect(func(_resource) -> void:
		last_state = self.visible
		self.visible = false
		)
	DialogueManager.dialogue_ended.connect(func(_resource) -> void: self.visible = last_state)

func update_interaction_prompt(target : CollisionObject3D) -> void:
	icon_npc.visible = target is NPC3D
	icon_interactable.visible = target is Interactable
	self.visible = is_instance_valid(target)
	
	if not is_instance_valid(target): return
	
	var key : String = Globals.get_input_string("interact")
	
	if target is NPC3D: 
		input_npc.text = key
	elif target is Interactable: 
		input_interactable.text = key

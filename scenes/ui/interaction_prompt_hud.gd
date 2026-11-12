extends Control

# --

@onready var icon_npc : TextureRect = $NPCPrompt
@onready var icon_interactable : TextureRect = $InteractablePrompt

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

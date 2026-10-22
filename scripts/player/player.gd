extends CharacterBody3D
class_name Player

# --

@onready var input : PlayerInput = $Input
@onready var movement : PlayerMovement = $Movement
@onready var visuals : PlayerVisuals = $Visuals
@onready var state_machine : StateMachine = $StateMachine

# --

func _ready() -> void:
	Globals.player = self
	AudioManager.setup_player(self)

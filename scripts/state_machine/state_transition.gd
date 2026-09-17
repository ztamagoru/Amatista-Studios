extends Node
class_name StateTransition

# --

@onready var source_state : State = get_parent()

@export var target_state : State

# --

var state_machine : StateMachine

var root:
	get:
		return state_machine.root

# --

func initialize(source : StateMachine) -> void:
	state_machine = source

# --

func can_transition() -> bool:
	return true

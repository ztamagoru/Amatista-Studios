extends Node
class_name State

# --

var state_machine : StateMachine

var root:
	get:
		return state_machine.root

# --

func initialize(source : StateMachine) -> void:
	state_machine = source

# --

func state_enter() -> void:
	pass

func state_process(_delta : float) -> void:
	pass
	
func state_phys_process(_delta : float) -> void:
	pass

func state_exit() -> void:
	pass

# --

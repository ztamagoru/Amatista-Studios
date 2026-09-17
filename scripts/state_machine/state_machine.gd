extends Node
class_name StateMachine

# --

signal state_changed(old_state : State, new_state : State)

# --

@export var root = get_parent()
@export_enum("Process", "Physics Process") var transition_process : int

# --

var states : Array[State]
var transitions : Dictionary[State, Array]

var current_state : State

# --

func _enter_tree() -> void:
	for child in get_children():
		if child is State:
			child.initialize(self)
			states.append(child)
			
			var new_transitions : Array[StateTransition]
			
			for grandkid in child.get_children():
				if grandkid is StateTransition:
					grandkid.initialize(self)
					new_transitions.append(grandkid)
					
			transitions.set(child, new_transitions)
	
	set_state(0)

# --

func set_state(index : int) -> void:
	if current_state:
		current_state.state_exit()
	
	state_changed.emit(current_state, states[index])
	
	current_state = states[index]
	
	current_state.state_enter()

func check_transitions() -> void:
	for transition in transitions[current_state]:
		if transition.can_transition():
			var new_index := states.find(transition.target_state)
			if new_index == -1:
				return
			
			set_state(new_index)

# --

func _process(delta: float) -> void:
	if !current_state:
		return
		
	if transition_process == 0:
		check_transitions()
	
	current_state.state_process(delta)

func _physics_process(delta: float) -> void:
	if !current_state:
		return
		
	if transition_process == 1:
		check_transitions()
	
	current_state.state_phys_process(delta)

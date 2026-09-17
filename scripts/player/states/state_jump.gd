extends State

# --

@export var movement_settings : MovementSettings
@export var jump_force : float = 50

# --

func state_enter() -> void:
	var player := root as Player
	
	player.velocity += Vector3.UP * jump_force



func state_phys_process(_delta : float) -> void:
	var player := root as Player
	
	player.movement.move(_delta, movement_settings)

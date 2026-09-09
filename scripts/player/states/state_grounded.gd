extends State

# --

@export var walk_settings : MovementSettings
@export var run_settings : MovementSettings

func state_phys_process(_delta : float) -> void:
	var player := root as Player
	
	player.movement.move(_delta, walk_settings if !player.input.is_running else run_settings)

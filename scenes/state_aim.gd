extends State

# --

@export var movement_settings : MovementSettings

# --

var last_aim_dir : Vector2

# --

func state_phys_process(_delta : float) -> void:
	var player := root as Player
	
	player.movement.move(_delta, movement_settings)
	
	if player.input.aim_dir.length() > 0:
		last_aim_dir = player.input.aim_dir

func state_exit() -> void:
	var player := root as Player

	print("Shoot!")
	
	last_aim_dir = Vector2.ZERO

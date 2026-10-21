extends State

# --

@export var walk_settings : MovementSettings

func state_enter() -> void:
	if !root.movement:
		return
	var surface := root.visuals.detect_surface() as String
	AudioManager.on_land(surface)

func state_phys_process(_delta : float) -> void:
	var player := root as Player

	player.movement.move(_delta, walk_settings)

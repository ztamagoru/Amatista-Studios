@tool
extends NPC

# --

@export var look_target : Node3D

@export_group("Navigation Settings")
@export var nav_agent : NavigationAgent3D
@export var nav_region : NavigationRegion3D

# --

const speed : float = 5.0

# --

var is_shy : bool
var is_alerted : bool = false

# --

func _ready():
	is_shy = bool(randi_range(0, 1))

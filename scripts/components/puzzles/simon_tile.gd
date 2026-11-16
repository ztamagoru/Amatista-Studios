extends StaticBody3D
class_name SimonTile

# --

signal stepped_on(tile : SimonTile)

# --

@export var stepping_area : Area3D

# --

var is_lit : bool = false

# --

func _ready() -> void:
	stepping_area.body_entered.connect(_on_body_entered)

# --

func _on_body_entered(body : Node3D) -> void:
	if body.is_in_group("player"):
		stepped_on.emit(self)
		print("AH M PISASTE CTM")

# --

func set_lit(value : bool) -> void:
	is_lit = value
	if is_lit: print(name)

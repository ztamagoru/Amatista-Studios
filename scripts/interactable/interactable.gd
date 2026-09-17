extends Area3D
class_name Interactable

# --

@export var dialogue_handler : DialogueHandler

# --

var can_interact : bool = false

var outline_material : StandardMaterial3D

# --

func _ready() -> void:
	pass

func _process(_delta: float) -> void:
	pass

# --

func show_outline() -> void:
	pass

func hide_outline() -> void:
	pass 

# --

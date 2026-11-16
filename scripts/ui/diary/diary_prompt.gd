extends HBoxContainer

# --

@onready var input_key : Label = $InputKey/Label

# --

func _ready() -> void:
	update_input_key()

# --

func update_input_key() -> void:
	input_key.text = Globals.get_input_string("toggle_diary")

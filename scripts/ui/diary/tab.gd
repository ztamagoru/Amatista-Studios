extends Button
class_name TabButton

# --

signal new_tab_selected(tab : TabButton)

# --

@export var entry_template : Control

# --

var initial_pos : Vector2
const mov_x : float = 25.0
const mov_duration : float = 0.5

var is_selected : bool = false

# --

func _ready() -> void:
	initial_pos = self.global_position
	connect("pressed", tab_pressed)

func tab_pressed() -> void:
	if not is_selected:
		is_selected = true
		move_tab(is_selected)
		
		new_tab_selected.emit(self)

func move_tab(direction : bool) -> void:
	var tween : Tween = create_tween()
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.set_ease(Tween.EASE_IN_OUT)
	
	var new_x : float = initial_pos.x - mov_x if direction else initial_pos.x
	tween.tween_property(self, "global_position:x", new_x, mov_duration) 

extends Map3D
class_name GameFinished

# --

@export_file_path("*.tscn") var main_menu_scene : String

@export var timer : Timer
@export var skip_progress_bar : TextureProgressBar

# --

const skip_held_time : float = 2.0

const _timer_duration : float = 3.0

var skip_timer : float = 0.0
var can_skip : bool = false


# --

func map_start() -> void:
	AudioManager.stop_music()
	
	skip_progress_bar.max_value = skip_held_time
	timer.start(_timer_duration)
	
	super.map_start()

func _process(delta: float) -> void:
	if transitioning: return
	if timer.time_left > 0.0: return
	
	if Input.is_action_pressed("skip_cutscene"):
		if not can_skip:
			skip_progress_bar.visible = true
			can_skip = true
			return
		
		if skip_timer >= skip_held_time:
			change_map(main_menu_scene)
		else: 
			skip_timer += delta
			skip_progress_bar.value = skip_timer
		
		return
	
	skip_timer = (skip_timer - delta) if skip_timer > 0.0 else 0.0
	skip_progress_bar.value = skip_timer

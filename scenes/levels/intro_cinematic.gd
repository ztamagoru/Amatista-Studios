extends Level
class_name Intro

# --

@export var intro_video : VideoStreamPlayer

@export_file_path("*.tscn") var tutorial_scene : String

@export var skip_progress_bar : TextureProgressBar

# --

const skip_held_time : float = 2.0

var skip_timer : float = 0.0
var can_skip : bool = false



# --

func level_start() -> void:
	skip_progress_bar.max_value = skip_held_time
	intro_video.finished.connect(func(): change_scene(tutorial_scene))
	AudioManager.stop_music()
	super.level_start()

func _process(delta: float) -> void:
	if transitioning: return
	
	if Input.is_action_pressed("skip_cutscene"):
		if not can_skip:
			skip_progress_bar.visible = true
			can_skip = true
			return
		
		if skip_timer >= skip_held_time:
			_transition()
			change_scene(tutorial_scene)
		else: 
			skip_timer += delta
			skip_progress_bar.value = skip_timer
		
		return
	
	skip_timer = (skip_timer - delta) if skip_timer > 0.0 else 0.0
	skip_progress_bar.value = skip_timer

func _transition() -> void:
	if intro_video.stream == null: return
	
	var sound_tween : Tween = create_tween()
	
	sound_tween.tween_property(intro_video, "volume_db", 0.0, game_manager.fade_duration).set_trans(Tween.TRANS_LINEAR)
	
	intro_video.paused = true

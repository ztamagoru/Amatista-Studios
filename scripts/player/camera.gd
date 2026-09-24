extends Node3D

# --

@export var player : CharacterBody3D
@export var camera : Camera3D
@export var pivot : Node3D

# --

const camera_speed : float = 3.0

const max_pitch : float = 0.3
const max_yaw : float = 0.5

var camera_original_rotation : Vector3

var pivot_original_position : Vector3
var pivot_original_rotation : Vector3

var tween : Tween

# --

func _ready():
	Globals.camera = self
	camera_original_rotation = camera.rotation_degrees
	
	pivot_original_position = pivot.position
	pivot_original_rotation = pivot.rotation_degrees

func _process(delta: float):
	if player:
		self.global_position = lerp(
			self.global_position,
			player.global_position,
			delta * camera_speed
		)

func move_camera(new_position : Vector3, new_rotation : Vector3, tween_duration : float = 1.5):
	if tween: tween.kill()
	
	tween = create_tween()
	tween.set_parallel(true)
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(pivot, "position", new_position, tween_duration)
	tween.tween_property(pivot, "rotation_degrees", new_rotation, tween_duration)

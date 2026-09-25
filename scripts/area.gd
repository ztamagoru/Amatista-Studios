@icon("res://assets/icons/area.svg")

extends Area3D
class_name Area

# --

@export_group("Camera")
@export_custom(PROPERTY_HINT_GROUP_ENABLE, "") var changes_camera : bool = false
@export var camera : Node3D
@export_range(0.5, 3.0, 0.1) var camera_movement_duration : float = 1.5
@export var camera_position : Vector3 = Vector3(8.0, 20.0, 20.0)
@export var camera_rotation : Vector3 = Vector3(-30.0, 0.0, 0.0)
@export_subgroup("Exits to another area")
@export_custom(PROPERTY_HINT_GROUP_ENABLE, "") var exits_to_another_area : bool
@export var parent_area : Area

# --

@export_group("Ground SFX")
@export_custom(PROPERTY_HINT_GROUP_ENABLE, "") var changes_sound : bool = false
@export var player : CharacterBody3D
@export var ground_type : String = ""

# --

func _ready() -> void:
	connect("body_entered", _on_body_entered)
	connect("body_exited", _on_body_exited)
	
	check_required()

func check_required():
	if exits_to_another_area: assert(not parent_area == null, "Parent area not assigned in %s" % name)
	if changes_sound:
		assert(not player == null, "Player not assigned in %s" % name)
		assert(ground_type in player.audio_footsteps, "Can't assign an unloaded sfx")

func _on_body_entered(body : Node3D):
	if body.is_in_group("player"):
		#body.current_area = self
		
		if changes_camera:
			camera.move_camera(camera_position, camera_rotation, camera_movement_duration)

func _on_body_exited(body : Node3D):
	if body.is_in_group("player"):
		#body.current_area = parent_area if exits_to_another_area else null
		
		if changes_camera: 
			camera.move_camera(
				parent_area.camera_position if exits_to_another_area else camera.pivot_original_position,
				parent_area.camera_rotation if exits_to_another_area else camera.pivot_original_rotation,
				camera_movement_duration
			)

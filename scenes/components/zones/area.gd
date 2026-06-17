@tool

extends Area3D
class_name Area

# --

@export_group("Camera")
@export_custom(PROPERTY_HINT_GROUP_ENABLE, "") var changes_camera : bool = false
@export var camera : Node3D
@export var camera_position : Vector3 = Vector3(8.0, 20.0, 20.0)
@export var camera_rotation : Vector3 = Vector3(-30.0, 0.0, 0.0)
@export_subgroup("Exits to another area")
@export_custom(PROPERTY_HINT_GROUP_ENABLE, "") var exits_to_another_area : bool
@export var parent_area : Area

# --

#@export_group("Footsteps SFX")
#@export_custom(PROPERTY_HINT_GROUP_ENABLE, "") var changes_sound : bool = false
#@export var new_sfx : 

# --

func _ready() -> void:
	connect("body_entered", _on_body_entered)
	connect("body_exited", _on_body_exited)

func _on_body_entered(body : Node3D):
	if body.is_in_group("player"):
		if changes_camera:
			camera.move_camera(camera_position, camera_rotation)

func _on_body_exited(body : Node3D):
	if body.is_in_group("player"):
		if changes_camera: 
			camera.move_camera(
				parent_area.camera_position if exits_to_another_area else camera.camera_original_position,
				parent_area.camera_rotation if exits_to_another_area else camera.camera_original_rotation
			)

extends MeshInstance3D
class_name FoliageBillboard

# --

@export var rotation_speed : float = 5.0
@export_range(0.0, 180.0) var max_angle : float = 60.0

# --

@onready var camera : Camera3D = get_viewport().get_camera_3d()

# --

func _process(delta: float) -> void:
	var direction : Vector3 = camera.global_position - self.global_position
	direction.y = 0.0
	
	if direction.length_squared() == 0.0: return
	
	var target_angle : float = atan2(direction.x, direction.z)
	var angle_difference : float = wrapf(target_angle - self.global_rotation.y, -PI, PI)
	var clamped_difference : float = clamp(angle_difference, deg_to_rad(-max_angle), deg_to_rad(max_angle))
	var target_rotation : float = self.global_position.y + clamped_difference
	
	global_rotation.y = lerp_angle(
		global_rotation.y,
		target_rotation,
		rotation_speed * delta
	)

extends RigidBody3D

var dir : Vector3 
var final_dir : Vector3

const speed : float = 6
const throw_height : float = 6

func _ready() -> void:
	await get_tree().process_frame
	
	final_dir = global_position.direction_to(dir) * speed
	final_dir.y += throw_height
	apply_impulse(final_dir)

func _process(_delta: float):
	if get_contact_count() > 0:
		for body in get_colliding_bodies():
			if not body.is_in_group("player"):
				queue_free()
		return

func _on_timer_timeout() -> void:
	queue_free()

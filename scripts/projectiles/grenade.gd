extends RigidBody3D

# --

@export var shoot_sfx : AudioStream

# --

var dir : Vector3 
var final_dir : Vector3

# --

const speed : float = 24
const throw_height : float = 24

# --

func _ready() -> void:
	await get_tree().process_frame
	
	var sfx : SFXOneShot = SFXOneShot.new()
	sfx.stream = shoot_sfx
	get_tree().current_scene.add_child(sfx)
	
	final_dir = global_position.direction_to(dir) * speed
	final_dir.y += throw_height
	apply_impulse(final_dir)

func _process(_delta: float):
	if get_contact_count() > 0:
		for body in get_colliding_bodies(): 
			if not body.is_in_group("player"):
				if body.is_in_group("sick_environment"):
					body.collision()
				queue_free()
		return

func _on_timer_timeout() -> void:
	queue_free()

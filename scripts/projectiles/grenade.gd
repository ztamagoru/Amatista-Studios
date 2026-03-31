extends RigidBody3D

var dir : Vector3 

const speed : float = 0

func _ready() -> void:
	apply_impulse(dir)
	pass

func _process(_delta: float):
	if get_contact_count() > 0:
		queue_free()

func _on_timer_timeout() -> void:
	queue_free()

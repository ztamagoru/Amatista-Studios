extends GPUParticles3D

# --

var target_projectile : Projectile

# --

func _physics_process(_delta: float) -> void:
	if is_instance_valid(target_projectile):
		self.global_position = target_projectile.global_position

func projectile_collided() -> void:
	self.emitting = false
	
	await get_tree().create_timer(lifetime).timeout
	queue_free()

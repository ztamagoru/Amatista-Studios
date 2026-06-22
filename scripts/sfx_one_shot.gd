extends AudioStreamPlayer
class_name SFXOneShot

# --

func _enter_tree() -> void:
	self.set_bus("SFX")
	
	finished.connect(func():
		queue_free()
	)
	play()

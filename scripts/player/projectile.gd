extends Path3D
class_name Projectile

# --

@export var shoot_sfx : AudioStream

@onready var proj_follow : PathFollow3D = $PathFollow3D
@onready var proj : Area3D = $PathFollow3D/Projectile

# --

var dir : Vector3

const speed : float = 15.0

# --

func _ready() -> void:
	await get_tree().process_frame
	
	if not shoot_sfx == null:
		var sfx : SFXOneShot = SFXOneShot.new()
		sfx.stream = shoot_sfx
		get_tree().current_scene.add_child(sfx)

func setup(player_pos : Vector3, target_pos : Vector3) -> void:
	self.global_position = player_pos
	curve.set_point_position(1, target_pos - player_pos)

func _physics_process(delta: float) -> void:
	var bodies : Array[Node3D] = proj.get_overlapping_bodies()
	
	if bodies.size() > 0:
		for body in proj.get_overlapping_bodies():
			if not body.is_in_group("player"):
				if body.is_in_group("sick_environment"):
					body.collision()
				queue_free()
	
	if proj_follow.progress_ratio >= 1.0:
		queue_free()
	
	proj_follow.progress += speed * delta

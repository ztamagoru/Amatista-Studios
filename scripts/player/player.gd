extends CharacterBody3D

@export var camera : Camera3D

const speed : float = 5.0
const crouch_speed : float = 4.0

var current_speed : float = speed

const jump_force : float = 3.5
const jump_velocity : float = 4.5
const gravity : float = 8.0

var mouse_position
var from
var ray_lenght : float = 1000

func _process(_delta) -> void:
	if Input.is_key_pressed(KEY_ESCAPE):
		get_tree().quit()
	
	var target_plane_mouse : Plane = Plane(Vector3(0,1,0), position.y)
	mouse_position = get_viewport().get_mouse_position()
	from = camera.project_ray_origin(mouse_position)
	var to = from + camera.project_ray_normal(mouse_position) * ray_lenght
	var cursor_position_on_plane = target_plane_mouse.intersects_ray(from, to)
	
	if cursor_position_on_plane:
		var target = cursor_position_on_plane
		target.y = $MeshInstance3D3.global_position.y
		$MeshInstance3D3.look_at(target, Vector3.UP)

#func _input(event: InputEvent) -> void:
	#pass

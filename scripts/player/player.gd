extends CharacterBody3D

# --

@export var camera : Camera3D
@export var timer : Timer

# --

@export var raycast : RayCast3D
@export var raycast_area : Area3D

@export_group("SFX")
@export_subgroup("Walking")
@export var walking_sfx : AudioStreamPlayer
@export var audio_footsteps : Dictionary[String, AudioStream]
@export var default_walking_sfx : String = ""

var current_area : Area
var current_footstep_sound : AudioStream

const raycast_max_distance : float = 15.0

# --

const speed : float = 25.0
const crouch_speed : float = 16.0

var current_speed : float = speed

const jump_force : float = 14.0
const jump_velocity : float = 16.0
const gravity : float = 24.0

# --

var can_shoot : bool = false

var mouse_position
var from
var ray_lenght : float = 4000
var cursor_position_on_plane

var projectile_scene = preload("res://scenes/components/projectiles/grenade.tscn")
const shoot_cd : float = 0.5

# --

func _ready() -> void:
	DialogueManager.dialogue_started.connect(_dialog_started)
	DialogueManager.dialogue_ended.connect(_dialog_ended)
	
	await check_required()
	
	walking_sfx.stream = audio_footsteps[default_walking_sfx]
	current_footstep_sound = audio_footsteps[default_walking_sfx]
	
	Globals.player = self

func check_required():
	assert(not audio_footsteps.is_empty(), "Needs to have at least one sfx loaded")
	assert(not default_walking_sfx == null, "Default walking sfx not assigned")
	assert(default_walking_sfx in audio_footsteps, "Can't assign an unloaded sfx as default")

func _process(_delta) -> void:
	if Input.is_key_pressed(KEY_ESCAPE):
		get_tree().quit()
	
	var target_plane_mouse : Plane = Plane(Vector3(0,1,0), position.y)
	mouse_position = get_viewport().get_mouse_position()
	from = camera.project_ray_origin(mouse_position)
	var to = from + camera.project_ray_normal(mouse_position) * ray_lenght
	cursor_position_on_plane = target_plane_mouse.intersects_ray(from, to)
	
	if cursor_position_on_plane:
		var target = cursor_position_on_plane
		target.y = $MeshInstance3D3.global_position.y
		$MeshInstance3D3.look_at(target, Vector3.UP)
		
		if raycast.enabled: rotate_raycast($MeshInstance3D3.global_transform.basis.z)

func rotate_raycast(mesh_transform : Vector3):
	var dir : Vector3 = -mesh_transform
	
	dir.y = 0
	dir = dir.normalized() * raycast_max_distance
	
	raycast.target_position = dir

func _physics_process(_delta: float):
	if raycast.enabled and raycast.is_colliding():
		detect_interactable()
	elif raycast.enabled and not raycast.is_colliding(): 
		Globals.hide_interactable_outline.emit()
	
	for body in raycast_area.get_overlapping_bodies():
		if body.is_in_group("interactable"):
			raycast.enabled = true
			return
	
	raycast.enabled = false

func _input(event: InputEvent):
	if event is InputEventMouseButton and not timer.time_left > 0:
		if not can_shoot:
			return
		
		var projectile = projectile_scene.instantiate()
		
		timer.start(shoot_cd)
		
		projectile.dir = cursor_position_on_plane
		get_tree().current_scene.add_child(projectile)
		projectile.global_position = global_position
		projectile.global_position.y += 4

func detect_interactable():
	var hit_object = raycast.get_collider()
	if not hit_object: return
	
	if hit_object.is_in_group("interactable"):
		Globals.set_interactable_outline.emit(hit_object.get_instance_id())

func _dialog_started(_resource: DialogueResource):
	self.process_mode = Node.PROCESS_MODE_DISABLED
	print("dialog started")
	pass

func _dialog_ended(_resource: DialogueResource):
	self.process_mode = Node.PROCESS_MODE_INHERIT
	print("dialog ended")
	pass

func _on_walking_sfx_finished() -> void:
	if current_area == null:
		if current_footstep_sound != audio_footsteps[default_walking_sfx]:
			current_footstep_sound = audio_footsteps[default_walking_sfx]
	else:
		if current_area.changes_sound and current_footstep_sound != audio_footsteps[current_area.ground_type]:
			current_footstep_sound = audio_footsteps[current_area.ground_type]
	
	walking_sfx.stream = current_footstep_sound
	walking_sfx.pitch_scale = randf_range(0.9, 1.1)
	walking_sfx.play(0.15)

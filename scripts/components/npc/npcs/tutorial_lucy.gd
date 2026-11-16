extends NPC3D

# --

var _is_moving : bool = false

# --

func run_away() -> void:
	if nav_region == null or nav_agent == null: return
	
	var nav_map := nav_region.get_navigation_map()
	
	for i in range(100):
		var random_position : Vector3 = Vector3(
			randf_range(-23.0, 57.0),
			0.0,
			randf_range(-866.0, -750.0)
		)
		
		var target_position := NavigationServer3D.map_get_closest_point(
			nav_map,
			random_position
		)
		
		if target_position.z >= -750.0: continue
		
		nav_agent.target_position = target_position
		_is_moving = true
		return

# --

func _physics_process(_delta: float) -> void: 
	if not _is_moving: return
	
	if nav_agent.is_navigation_finished():
		_is_moving = false
		velocity = Vector3.ZERO
		move_and_slide()
		return
	
	var next_position : Vector3 = nav_agent.get_next_path_position()
	var direction : Vector3 = global_position.direction_to(next_position)
	
	velocity = direction * speed
	move_and_slide()
	if get_slide_collision_count() > 0: 
		print("Lucy collision: ", get_slide_collision(0).get_collider())

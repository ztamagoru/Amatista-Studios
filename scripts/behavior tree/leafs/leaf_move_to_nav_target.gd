extends Leaf
class_name LeafMoveToNavTarget

## Moves owner to it's [NavigationAgent3D]'s [code]target_position[/code]
##
## Owner needs to have a [code]speed[/code] variable declared in order
## to work properly. 

@export var rotation_speed : float = 2.5

func step() -> Result:
	var direction = (
		owner.nav_agent.get_next_path_position() - owner.global_position
	).normalized()
	
	owner.velocity = owner.speed * direction
	
	var current_rotation = owner.global_transform.basis.get_rotation_quaternion()
	var target_rotation = owner.basis.looking_at(direction, Vector3.UP).get_rotation_quaternion()
	var new_rotation = current_rotation.slerp(target_rotation, rotation_speed * get_physics_process_delta_time())
	
	owner.global_transform.basis = Basis(new_rotation)
	
	if owner.global_position.distance_to(owner.nav_agent.target_position) < owner.velocity.length() * get_physics_process_delta_time():
		owner.global_position = owner.nav_agent.target_position
		owner.velocity = Vector3.ZERO
		return Result.SUCCESS
	
	owner.move_and_slide()
	return Result.RUNNING

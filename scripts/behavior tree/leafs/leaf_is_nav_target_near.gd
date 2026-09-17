extends Leaf
class_name LeafIsNavTargetNear

func step() -> Result:
	if owner.global_position.distance_to(owner.nav_agent.target_position) < owner.velocity.length() * get_physics_process_delta_time():
		owner.global_position = owner.nav_agent.target_position
		owner.velocity = Vector3.ZERO
		return Result.SUCCESS
	
	return Result.FAILURE

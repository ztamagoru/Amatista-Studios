extends Leaf
class_name LeafIsNavTargetNear

## Checks if [NavigationAgent3D]'s [code]target_position[/code] is
## near the owner.
## 
## Compares owner's [code]velocity lenght[/code] to the distance
## between itself and the [NavigationAgent3D]'s
## [code]target_position[/code].

func step() -> Result:
	if owner.global_position.distance_to(owner.nav_agent.target_position) < owner.velocity.length() * get_physics_process_delta_time():
		owner.global_position = owner.nav_agent.target_position
		owner.velocity = Vector3.ZERO
		return Result.SUCCESS
	
	return Result.FAILURE

extends Leaf
class_name LeafLookAt

## Changes owner's rotation based on target's [global_position].
##
## Target needs to be declared as [code]lookt_target[/code]
## inside of a script attached to owner.

@export var rotation_speed : float = 2.5

func step() -> Result:
	var direction = (
		owner.look_target.global_position - owner.global_position
	).normalized()
	
	var current_rotation = owner.global_transform.basis.get_rotation_quaternion()
	var target_rotation = owner.basis.looking_at(direction, Vector3.UP).get_rotation_quaternion()
	var new_rotation = current_rotation.slerp(target_rotation, rotation_speed * get_physics_process_delta_time())
	
	owner.global_transform.basis = Basis(new_rotation)
	
	return Result.SUCCESS

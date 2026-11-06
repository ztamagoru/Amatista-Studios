extends Leaf
class_name LeafMoveToNavTarget

## Moves owner to it's [NavigationAgent3D]'s [code]target_position[/code]
##
## Owner needs to have a [code]speed[/code] variable declared in order
## to work properly. 

@export var rotation_speed : float = 2.5

@onready var npc : NPC = owner.get_parent() as NPC

func step() -> Result:
	var direction = (
		npc.nav_agent.get_next_path_position() - npc.global_position
	).normalized()
	
	npc.velocity = npc.speed * direction
	
	var current_rotation = npc.global_transform.basis.get_rotation_quaternion()
	var target_rotation = npc.basis.looking_at(direction, Vector3.UP).get_rotation_quaternion()
	var new_rotation = current_rotation.slerp(target_rotation, rotation_speed * get_physics_process_delta_time())
	
	npc.global_transform.basis = Basis(new_rotation)
	
	if npc.global_position.distance_to(npc.nav_agent.target_position) < npc.velocity.length() * get_physics_process_delta_time():
		npc.global_position = npc.nav_agent.target_position
		npc.velocity = Vector3.ZERO
		return Result.SUCCESS
	
	npc.move_and_slide()
	return Result.RUNNING

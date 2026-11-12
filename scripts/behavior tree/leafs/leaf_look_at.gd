extends Leaf
class_name LeafLookAt

## Changes owner's rotation based on target's [global_position].
##
## Target needs to be declared as [code]lookt_target[/code]
## inside of a script attached to owner.

## Velocity at which the NPC3D rotates
@export var rotation_speed : float = 2.5

@onready var npc : NPC3D = owner.get_parent() as NPC3D

# --

func step() -> Result:
	var direction = (
		npc.target_look.global_position - npc.global_position
	).normalized()
	
	var current_rotation = npc.global_transform.basis.get_rotation_quaternion()
	var target_rotation = npc.basis.looking_at(direction, Vector3.UP).get_rotation_quaternion()
	var new_rotation = current_rotation.slerp(target_rotation, rotation_speed * get_physics_process_delta_time())
	
	npc.global_transform.basis = Basis(new_rotation)
	
	return Result.SUCCESS

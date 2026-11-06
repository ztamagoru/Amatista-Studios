extends Leaf
class_name LeafIsNavTargetNear

## Checks if [NavigationAgent3D]'s [code]target_position[/code] is
## near the owner.
## 
## Compares owner's [code]velocity lenght[/code] to the distance
## between itself and the [NavigationAgent3D]'s
## [code]target_position[/code].

@onready var npc : NPC = owner.get_parent() as NPC

func step() -> Result:
	if npc.global_position.distance_to(npc.nav_agent.target_position) < npc.velocity.length() * get_physics_process_delta_time():
		npc.global_position = npc.nav_agent.target_position
		npc.velocity = Vector3.ZERO
		return Result.SUCCESS
	
	return Result.FAILURE

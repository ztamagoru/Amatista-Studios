extends Leaf
class_name LeafIsNavTargetEmpty

## Checks if [NavigationAgent3D]'s [code]target_position[/code] is
## [code]Vector3.ZERO[/code] or has some other value in it.

@onready var npc : NPC3D = owner.get_parent() as NPC3D

func step() -> Result:
	return Result.SUCCESS if npc.nav_agent.target_position == Vector3.ZERO else Result.FAILURE

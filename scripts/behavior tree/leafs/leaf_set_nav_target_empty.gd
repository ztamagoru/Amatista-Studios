extends Leaf
class_name LeafSetNavTargetEmpty

## Sets owner's [NavigationAgent3D]'s target position to null
##
## Owner needs to have a [NavigationAgent3D] node declared on an
## attached script.

@onready var npc : NPC3D = owner.get_parent() as NPC3D

func step() -> Result:
	npc.nav_agent.target_position = Vector3.ZERO
	return Result.SUCCESS

extends Leaf
class_name LeafSetNavTargetPosition

## Sets owner's [NavigationAgent3D]'s target position to a random
## position inside of a [NavigationRegion3D].
##
## Owner needs to have a [NavigationAgent3D] node and a
## [NavigationRgion3D] node declared on an attached script. 

@onready var npc : NPC = owner.get_parent() as NPC

func step() -> Result:
	var map_rid : RID = npc.nav_region.get_rid()
	var random_point = NavigationServer3D.region_get_random_point(map_rid, 1, false)
	
	npc.nav_agent.target_position = random_point
	
	return Result.SUCCESS

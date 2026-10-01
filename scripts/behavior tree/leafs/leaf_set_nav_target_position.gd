extends Leaf
class_name LeafSetNavTargetPosition

## Sets owner's [NavigationAgent3D]'s target position to a random
## position inside of a [NavigationRegion3D].
##
## Owner needs to have a [NavigationAgent3D] node and a
## [NavigationRgion3D] node declared on an attached script. 

func step() -> Result:
	var map_rid : RID = owner.nav_region.get_navigation_map()
	var random_point = NavigationServer3D.map_get_random_point(map_rid, 1, false)
	
	owner.nav_agent.target_position = random_point
	
	return Result.SUCCESS

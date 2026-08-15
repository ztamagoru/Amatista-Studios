extends Leaf
class_name LeafSetNavTargetPosition

func step() -> Result:
	var map_rid : RID = owner.nav_region.get_navigation_map()
	var random_point = NavigationServer3D.map_get_random_point(map_rid, 1, false)
	
	owner.nav_agent.target_position = random_point
	
	return Result.SUCCESS

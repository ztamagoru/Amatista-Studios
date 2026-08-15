extends Leaf
class_name LeafIsNavTargetEmpty

func step() -> Result:
	return Result.SUCCESS if owner.nav_agent.target_position == Vector3.ZERO else Result.FAILURE

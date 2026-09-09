extends Leaf
class_name LeafIsPlayerInsideArea3D

@export var range_area : Area3D

func step() -> Result:
	for body in range_area.get_overlapping_bodies():
		if body == Globals.player:
			return Result.SUCCESS
	return Result.FAILURE

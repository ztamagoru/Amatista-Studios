extends Leaf
class_name LeafCheckBool

@export var property_name : String

func step() -> Result:
	return Result.SUCCESS if owner.get(property_name) else Result.FAILURE

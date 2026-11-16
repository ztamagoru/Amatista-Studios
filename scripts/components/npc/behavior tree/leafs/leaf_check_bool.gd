extends Leaf
class_name LeafCheckBool

## Checks owner's desired bool value.

@export var property_name : String

func step() -> Result:
	return Result.SUCCESS if owner.get(property_name) else Result.FAILURE

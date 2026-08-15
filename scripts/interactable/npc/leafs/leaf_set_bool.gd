extends Leaf
class_name LeafSetBool

@export var property_name : String
@export var turn_to : bool

func step() -> Result:
	owner.set(property_name, turn_to)
	return Result.SUCCESS

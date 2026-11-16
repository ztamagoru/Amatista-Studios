extends Leaf
class_name LeafCheckTimer

## Checks if selected [Timer] has finished.

@export var timer : Timer

func step() -> Result:
	if timer.time_left > 0: return Result.SUCCESS
	return Result.FAILURE

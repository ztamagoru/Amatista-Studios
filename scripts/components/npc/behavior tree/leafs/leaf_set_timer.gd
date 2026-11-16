extends Leaf
class_name LeafSetTimer

## Sets [Timer] to a specific duration.
## 
## If [code]random_duration[/code] is set to true, the timer duration is
## randomly generated between the values declared in [code]min_duration[/code]
## and [code]max_duration[/code].

@export var timer : Timer
@export var duration : float = 1.0

@export_group("Random duration")
@export_custom(PROPERTY_HINT_GROUP_ENABLE, "") var random_duration : bool = false
@export var min_duration : float
@export var max_duration : float

func step() -> Result:
	if random_duration: timer.start(randf_range(min_duration, max_duration))
	else: timer.start(duration)
	return Result.SUCCESS

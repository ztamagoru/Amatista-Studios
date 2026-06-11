@icon("res://assets/icons/behavior tree/selector.svg")

extends Composite
class_name CompositeSelector

func step() -> Result:
	var children = get_children()
	if random_order: children.shuffle()
	
	for child : BehaviorNode in children:
		var child_result = child.step()
		if child_result != Result.SUCCESS:
			return child_result
	return Result.SUCCESS

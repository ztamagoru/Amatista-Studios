extends Leaf
class_name LeafSetAnimationBlend

## Sets an [AnimationTree]'s [code]blend_position[/code] parameter
## to desired value.

@export var anim_tree : AnimationTree
@export var blend_value : float

func step() -> Result:
	anim_tree.set("parameters/blend_position", blend_value)
	return Result.SUCCESS

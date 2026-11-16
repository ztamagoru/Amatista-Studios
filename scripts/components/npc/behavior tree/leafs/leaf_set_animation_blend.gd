extends Leaf
class_name LeafSetAnimationBlend

## Sets an [AnimationTree]'s [code]blend_position[/code] parameter
## to desired value.

@export var blend_value : float = 1

@onready var npc : NPC3D = owner.get_parent() as NPC3D

func step() -> Result:
	npc.anim_tree.set("parameters/blend_position", blend_value)
	return Result.SUCCESS

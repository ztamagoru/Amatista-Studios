extends Leaf
class_name LeafIsPlayerInsideArea3D

## Checks if the player is inside of exported [Area3D].
## 
## Player needs to be declared inside of [Globals] in order to work.

@onready var npc : NPC3D = owner.get_parent() as NPC3D

func step() -> Result:
	for body in npc.target_detection_area.get_overlapping_bodies():
		if body == Globals.player:
			return Result.SUCCESS
	return Result.FAILURE

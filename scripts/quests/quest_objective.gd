extends Resource
class_name QuestObjective

# --

enum ObjectiveType {
	EVENT,
	COLLECT_ITEM,
	DELIVER_ITEM,
}

# --

@export var id : StringName
@export var description : String
@export var type : ObjectiveType = ObjectiveType.EVENT

## For objectives of type EVENT.
@export var event_id : StringName

## For objectives of type COLLECT_ITEM or DELIVER_ITEM.
@export var item_id : StringName
@export_range (1, 99) var required_amount : int = 1

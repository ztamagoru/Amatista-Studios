@tool
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
@export var type : ObjectiveType = ObjectiveType.EVENT:
	set(value):
		if type != value:
			type = value
			notify_property_list_changed()

## For objectives of type EVENT.
@export var event_id : StringName

## For objectives of type COLLECT_ITEM or DELIVER_ITEM.
@export var item_id : StringName
@export_range (1, 99) var required_amount : int = 1

# --

func _validate_property(property: Dictionary) -> void:
	if property.name == "event_id":
		if type != ObjectiveType.EVENT:
			property.usage &= ~PROPERTY_USAGE_EDITOR
			
	if property.name == "item_id" or property.name == "required_amount":
		if type == ObjectiveType.EVENT:
			property.usage &= ~PROPERTY_USAGE_EDITOR

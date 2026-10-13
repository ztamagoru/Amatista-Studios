@tool
extends Resource
class_name QuestResource

# --

enum Subquestmode {
	ALL,				# has to complete all subquests
	SEQUENCE,			# gives one subquest at a time
	RANDOM_SEQUENCE,	# selects random subquests, one at a time
}

# --

@export_group("General")
@export var id : StringName
@export var title : String
@export_multiline var description : String

@export_group("Objectives")
@export var objectives : Array[QuestObjective] = []

@export_group("Subquests")
@export var subquests : Array[QuestResource] = []:
	set(value):
		subquests = value
		notify_property_list_changed()
@export var subquest_mode : Subquestmode = Subquestmode.ALL:
	set(value):
		if subquest_mode != value:
			subquest_mode = value
			notify_property_list_changed()
@export_range(1,10) var required_subquests : int = 1

# --

func _validate_property(property: Dictionary) -> void:
	if property.name == "required_subquests":
		if subquests.is_empty() or subquest_mode != Subquestmode.RANDOM_SEQUENCE:
			property.usage &= ~PROPERTY_USAGE_EDITOR
	if property.name == "subquest_mode":
		if subquests.is_empty():
			property.usage &= ~PROPERTY_USAGE_EDITOR
	

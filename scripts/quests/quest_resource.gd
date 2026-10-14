@tool
extends Resource
class_name QuestResource

# --

enum SubquestMode {
	## Has to complete all subquests.
	ALL,
	## Gives one subquest at a time.
	SEQUENCE,
	## Selects random subquests, one at a time.
	RANDOM_SEQUENCE,
}

enum ObjectiveMode {
	## Objectives must be completed as they are listed on [code]objectives[/code].
	SEQUENCE,
	## Objectives can be completed in any order.
	ALL,
}

# --

@export_group("General")
@export var id : StringName
@export var title : String
@export_multiline var description : String

# --

@export_group("Objectives")
@export var objectives : Array[QuestObjective] = []:
	set(value):
		objectives = value
		notify_property_list_changed()
@export var objective_mode : ObjectiveMode = ObjectiveMode.SEQUENCE

# --

@export_group("Subquests")
@export var subquests : Array[QuestResource] = []:
	set(value):
		subquests = value
		notify_property_list_changed()
@export var subquest_mode : SubquestMode = SubquestMode.ALL:
	set(value):
		if subquest_mode != value:
			subquest_mode = value
			notify_property_list_changed()
@export_range(1,10) var required_subquests : int = 1

# --

func _validate_property(property: Dictionary) -> void:
	if property.name == "required_subquests":
		if subquests.is_empty() or subquest_mode != SubquestMode.RANDOM_SEQUENCE:
			property.usage &= ~PROPERTY_USAGE_EDITOR
	
	if property.name == "objective_mode":
		if objectives.is_empty():
			property.usage &= ~PROPERTY_USAGE_EDITOR
	
	if property.name == "subquest_mode":
		if subquests.is_empty():
			property.usage &= ~PROPERTY_USAGE_EDITOR
	

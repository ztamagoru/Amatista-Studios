extends Resource
class_name QuestResource

# --

@export var id : StringName
@export var title : String
@export_multiline var description : String

@export var objectives : Array[QuestObjective] = []
@export var subquests : Array[QuestResource] = []

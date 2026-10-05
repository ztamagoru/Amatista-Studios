extends Resource
class_name DiaryEntry

var id : StringName
var name : StringName
var title : String
var description : String
var fun_fact : String

# --

class NPCEntry extends DiaryEntry:
	var species : String
	
	func _init(_id : StringName, _name : StringName, _species : String, _title : String, _description : String, _fun_fact : String) -> void:
		id = _id
		name = _name
		species = _species
		title = _title
		description = _description
		fun_fact = _fun_fact

# --

class PlantEntry extends DiaryEntry:
	func _init(_id : StringName, _name : StringName, _title : String, _description : String, _fun_fact : String) -> void:
		id = _id
		name = _name
		title = _title
		description = _description
		fun_fact = _fun_fact

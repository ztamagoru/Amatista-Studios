extends Label
class_name ObjectiveEntry

# --

func setup(objective_data : Dictionary) -> void:
	self.text = "• " + objective_data["description"]
	
	if objective_data["required"] > 1:
		self.text += " (%d/%d)" % [
			objective_data["progress"],
			objective_data["required"]
		]

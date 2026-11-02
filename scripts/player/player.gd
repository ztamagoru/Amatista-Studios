extends CharacterBody3D
class_name Player

# --

@onready var input : PlayerInput = $Input
@onready var movement : PlayerMovement = $Movement
@onready var visuals : PlayerVisuals = $Visuals
@onready var state_machine : StateMachine = $StateMachine

# --

var skills : Dictionary = {}

# --

func _ready() -> void:
	Globals.player = self
	AudioManager.setup_player(self)
	
	skills = {
		"slingshot": false,
		"jump": false,
	}
	
	_update_skills()

# --

func unlock_skill(skill_id : StringName) -> void:
	if not skills.has(skill_id): return
	if skills[skill_id]: return

	skills[skill_id] = true
	
	var unlocked : Array = []
	
	for skill in skills:
		if skills[skill]: unlocked.append(skill)
	
	SaveManager.save_section("skills", unlocked)

# --

func _update_skills() -> void:
	var saved_skills : Array = SaveManager.load_array_section("skills")
	if saved_skills == null: return
	
	for skill in saved_skills:
		if skills.has(skill):
			skills[skill] = true

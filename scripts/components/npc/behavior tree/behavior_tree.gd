@icon("res://assets/icons/behavior tree/tree.svg")

extends Node
class_name BehaviorTree

@export var one_shot : bool = false

var starter_behavior : BehaviorNode

func _ready():
	for child in get_children():
		if child is BehaviorNode:
			starter_behavior = child
			break
	
	if starter_behavior != null: 
		if one_shot: starter_behavior.step()

func _physics_process(_delta: float) -> void:
	if not one_shot: starter_behavior.step()

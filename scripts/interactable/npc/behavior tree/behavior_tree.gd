@icon("res://assets/icons/behavior tree/tree.svg")

extends Node
class_name BehaviorTree

var starter_behavior

func _ready():
	for child in get_children():
		if child is BehaviorNode:
			starter_behavior = child
			break

func _physics_process(_delta: float) -> void:
	starter_behavior.step()

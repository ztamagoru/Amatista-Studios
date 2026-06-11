@icon("res://assets/icons/behavior tree/behavior_node.svg")
@abstract

extends Node
class_name BehaviorNode

enum Result {SUCCESS, FAILURE, RUNNING}

@abstract func step() -> Result

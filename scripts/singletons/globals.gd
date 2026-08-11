extends Node

# --

signal set_interactable_outline(object_id : int)
signal hide_interactable_outline

# --

var player : CharacterBody3D

var current_trees : Array[Sick_Environment] = []

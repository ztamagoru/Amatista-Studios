@tool
extends Item
class_name ItemFlower

# --

enum FlowerType {
	LUPINA,
	AMANCAY,
	MUTISIA,
}

# --

@export_group("Flower Model")
@export var flower_type : FlowerType = FlowerType.LUPINA:
	set(value):
		flower_type = value
		_update_model()

# --

func _ready() -> void:
	if Engine.is_editor_hint():
		_update_model()
		return
	
	super._ready()
	if not should_initialize: return

func _update_model() -> void:
	var lupina_model := get_node_or_null("FlowerModels/flower_violet")
	var amancay_model := get_node_or_null("FlowerModels/flower_yellow")
	var mutisia_model := get_node_or_null("FlowerModels/flower_orange")
	
	if is_instance_valid(lupina_model):
		lupina_model.visible = flower_type == FlowerType.LUPINA

	if is_instance_valid(mutisia_model):
		mutisia_model.visible = flower_type == FlowerType.MUTISIA

	if is_instance_valid(amancay_model):
		amancay_model.visible = flower_type == FlowerType.AMANCAY

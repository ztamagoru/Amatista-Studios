@tool
extends MultiMeshInstance3D

func start_multimesh():
	multimesh = MultiMesh.new()
	multimesh.instance_count = 0
	multimesh.use_custom_data = true
	multimesh.transform_format = MultiMesh.TRANSFORM_3D

@export_tool_button("Set Multimeshes", "MeshInstance3D") var set_multimesh_action = set_multimeshes
func set_multimeshes():
	start_multimesh()
	multimesh.instance_count = get_child_count()
	for child : Node3D in get_children():
		var _transform = Transform3D(Basis(),child.position)
		multimesh.set_instance_transform(child.get_index(),_transform)
	set_collisions()

func _ready() -> void: set_collisions.call_deferred()

@export_tool_button("Set Collisions", "CollisionShape3D") var set_collision_action = set_collisions
@export var cylinder_height : float = 30.0
@export var cylinder_radius : float = 1.25
func set_collisions():
	for instance in range(multimesh.instance_count):
		var col_pos = multimesh.get_instance_transform(instance)
		var body := Sick_Environment.new()
		body.owner = get_tree().edited_scene_root
		body.tree_instance = instance
		get_parent().add_child(body)
		body.add_to_group("sick_environment")
		body.tree_healing.connect(change_tree_texture)
		body.global_position = to_global(col_pos.origin)
		var col := CollisionShape3D.new()
		body.add_child(col)
		var shape := CylinderShape3D.new()
		shape.radius = cylinder_radius
		shape.height = cylinder_height
		col.shape = shape

func change_tree_texture(instance : int):
	var t := get_tree().create_tween()
	var callable = func(col, ins): multimesh.set_instance_custom_data(ins, col)
	t.tween_method(callable.bind(instance), Color(0,0,0), Color(1,0,0), 1)
	print("hi")

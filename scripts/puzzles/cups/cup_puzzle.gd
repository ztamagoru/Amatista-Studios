extends Node3D

@onready var markers : Array[Node3D] = [$Markers/Marker1, $Markers/Marker2, $Markers/Marker3]
@onready var cups : Array[Node3D] = [$Cups/Cup1, $Cups/Cup2, $Cups/Cup3]

@onready var path_1 : CupPath = $Paths/Path1
@onready var path_2 : CupPath = $Paths/Path2

func shuffle_cups():
	var rand_1 : int = randi_range(0, 2)
	var rand_2 : int = randi_range(0, 2)
	while rand_2 == rand_1: rand_2 = randi_range(0, 2)
	
	var cup_1 = cups[rand_1]
	var cup_2 = cups[rand_2]
	
	var marker_1 = markers[rand_1]
	var marker_2 = markers[rand_2]
	
	path_1.remote.remote_path = cup_1.get_path()
	path_2.remote.remote_path = cup_2.get_path()
	
	path_1.curve.set_point_position(0, marker_1.global_position)
	path_2.curve.set_point_position(0, marker_2.global_position)
	
	path_1.curve.set_point_position(1, marker_2.global_position)
	path_2.curve.set_point_position(1, marker_1.global_position)
	
	path_1.follow.progress_ratio = 0
	path_2.follow.progress_ratio = 0
	
	cups[rand_1] = cup_2
	cups[rand_2] = cup_1
	
	create_tween().tween_property(path_1.follow, "progress_ratio", 1, 0.5)
	create_tween().tween_property(path_2.follow, "progress_ratio", 1, 0.5)
	
	await get_tree().create_timer(0.6).timeout

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("interact"):
		for i in randi_range(5,10): await shuffle_cups()


#func _ready() -> void:
	##shuffle_cups()
	#for i in randi_range(3, 7):
		#await shuffle_cups()

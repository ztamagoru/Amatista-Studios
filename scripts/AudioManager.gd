extends Node

var bank_loaded := false
var player: CharacterBody3D
var _audio_ready := false

func _ready() -> void:
	if not bank_loaded:
		Wwise.register_game_obj(self, "AudioManager")
		Wwise.load_bank("Main")
		Wwise.add_default_listener(self)
		bank_loaded = true

func setup_player(player_node: CharacterBody3D) -> void:
	if _audio_ready != null:
		return
	#player = player_node
	Wwise.register_game_obj(player, "Player")
	Wwise.add_default_listener(self)

func _emitter() -> Object:
	return player if is_instance_valid(player) else self

func on_footstep(surface: String) -> void:
	if _audio_ready == null:
		return
	#print("FOOTSTEP -> Superficie: ", surface)
	Wwise.set_switch("Material", surface, _emitter())
	#print("FOOTSTEP -> Switch enviado: Material / ", surface)
	Wwise.post_event("Footstep", _emitter())
	#print("FOOTSTEP -> Evento enviado: Footstep")

func on_shoot() -> void:
	if _audio_ready == null:
		return
	#print("SHOOT -> Evento enviado")
	Wwise.post_event("Shoot", _emitter())
	
func on_jump(surface) -> void:
	if _audio_ready == null:
		return
	Wwise.set_switch("Material", surface, _emitter())
	Wwise.post_event("Jump", _emitter())

func on_land(surface) -> void:
	if _audio_ready == null:
		return
	Wwise.set_switch("Material", surface, _emitter())
	Wwise.post_event("Land", _emitter())

#Hud
func on_page_turn() -> void:
	if _audio_ready == null:
		return
	Wwise.post_event("Pages_Turn", _emitter())

func on_close_diary() -> void:
	if _audio_ready == null:
		return
	Wwise.post_event("Close_Diary", _emitter())

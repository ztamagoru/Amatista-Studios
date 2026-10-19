extends Node

var bank_loaded := false
var player: CharacterBody3D
var _audio_ready := false
var _pending_music := ""

func _ready() -> void:
		Wwise.register_game_obj(self, "AudioManager")
		Wwise.load_bank("Main")
		Wwise.add_default_listener(self)
	
		Wwise.set_rtpc_value("Master", 100, self)
		Wwise.set_rtpc_value("Music", 100, self)
		Wwise.set_rtpc_value("SFX", 100, self)
		bank_loaded = true
		_audio_ready = true
		
		if _pending_music != "":
			var key := _pending_music
			_pending_music = ""
			play_music(key)

func setup_player(player_node: CharacterBody3D) -> void:
	if _audio_ready != null:
		return
	Wwise.register_game_obj(player, "Player")
	Wwise.add_default_listener(self)

func set_value(value_name : String, value : float) -> void:
	Wwise.set_rtpc_value(value_name, value, self)

#---------------------------------Player---------------------------------------
func on_footstep(surface: String) -> void:
	if _audio_ready == null:
		return
	#print("FOOTSTEP -> Superficie: ", surface)
	Wwise.set_switch("Material", surface, self)
	#print("FOOTSTEP -> Switch enviado: Material / ", surface)
	Wwise.post_event("Footstep", self)
	#print("FOOTSTEP -> Evento enviado: Footstep")

func on_shoot() -> void:
	if _audio_ready == null:
		return
	#print("SHOOT -> Evento enviado")
	Wwise.post_event("Shoot", self)
	
func on_jump(surface) -> void:
	if _audio_ready == null:
		return
	Wwise.set_switch("Material", surface, self)
	Wwise.post_event("Jump", self)

func on_land(surface) -> void:
	if _audio_ready == null:
		return
	Wwise.set_switch("Material", surface, self)
	Wwise.post_event("Land", self)

#------------------------------------Game---------------------------------------
func on_heal() -> void:
	if _audio_ready == null:
		return
	Wwise.post_event("Heal", self)

func on_not_heal()-> void:
	if _audio_ready == null:
		return
	Wwise.post_event("Not_heal", self)

func on_pick_item()-> void:
	if _audio_ready == null:
		return
	Wwise.post_event("Pick_up", self)

func on_discovery()-> void:
	if _audio_ready == null:
		return
	Wwise.post_event("Discovery", self)

func on_collectable()-> void:
	if _audio_ready == null:
		return
	Wwise.post_event("Collectable", self)

func correct_puzzle()-> void:
	if _audio_ready == null:
		return
	Wwise.post_event("Correct_Puzzle", self)

func incorrect_puzzle()-> void:
	if _audio_ready == null:
		return
	Wwise.post_event("Incorrect_Puzzle", self)

#------------------------------------Hud--------------------------------------
func on_page_turn() -> void:
	if _audio_ready == null:
		return
	Wwise.post_event("Pages_Turn", self)

func on_close_diary() -> void:
	if _audio_ready == null:
		return
	Wwise.post_event("Close_Diary", self)

func on_open_diary() -> void:
	if _audio_ready == null:
		return
	Wwise.post_event("Open_Diary", self)

#------------------------------------Music----------------------------------------
const music_switchs := {
	"menu": "Menu",
	"tutorial": "Tutorial",
	"garden": "Garden",
}

var _music_playing := false
var _current_music := ""

func play_music(key: String) -> void:
	if not _audio_ready:
		_pending_music = key
		return
	if key == _current_music:
		return
	if not music_switchs.has(key):
		push_warning("AUDIO -> No hay switch de música para: " + key)
		return
	
	Wwise.set_switch("Switch_Music", music_switchs[key], self)
	print("MUSIC -> Switch: ", music_switchs[key])
	
	if not _music_playing:
		Wwise.post_event("Play_Music", self)
		_music_playing = true
	
	_current_music = key

func stop_music(_fade_ms: int = 1000) -> void:
	Wwise.post_event("Stop_Music", self)
	_music_playing = false
	_current_music = ""

#func game_start():
	#Wwise.post_event("Play_Music_Menu", self)
	#
#func play_music_menu():
	#Wwise.post_event("Play_Music_Menu", self)
#
#func play_music_tutorial():
	#Wwise.post_event("Play_Music_Tutorial", self)
#
#func play_music_garden():
	#Wwise.post_event("Play_Music_Garden", self)

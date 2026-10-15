extends Node

var bank_loaded := false
var player_speed: float = 0.0
var player: CharacterBody3D


func _ready() -> void:
	
	Wwise.load_bank("Main")
	print("AUDIO -> Bank Main solicitado")
	bank_loaded = true

func setup_player(player_node: CharacterBody3D) -> void:
	if player != null:
		return
	player = player_node
	Wwise.register_game_obj(player, "Player")
	Wwise.register_listener(player)
	print("AUDIO -> Player registrado en Wwise")


func on_footstep(surface: String) -> void:
	if player == null:
		print("AUDIO ERROR -> Player todavía no está configurado")
		return

	print("FOOTSTEP -> Superficie: ", surface)

	Wwise.set_switch("Material", surface, player)
	print("FOOTSTEP -> Switch enviado: Material / ", surface)

	Wwise.post_event("Footstep", player)
	print("FOOTSTEP -> Evento enviado: Footstep")


func on_shoot() -> void:
	if player == null:
		print("AUDIO ERROR -> Player todavía no está configurado")
		return

	print("SHOOT -> Evento enviado")

	Wwise.post_event("Shoot", player)
	
func on_jump(surface) -> void:
	if player == null:
		print("AUDIO ERROR -> Player todavía no está configurado")
		return
	Wwise.set_switch("Material", surface, player)
	Wwise.post_event("Jump", player)

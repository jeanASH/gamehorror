extends Node2D
@export var piano: AudioStream 
func _ready():
	MissaoManager.carregar_missao_do_save_atual()
	
	if piano != null:
		AudioManager.tocar_ambiente(piano, 1.0, "SFX")
	AudioManager.parar_musica(1.5)
	
	
	var player = get_tree().current_scene.find_child("Player", true, false)
	if player and "pode_usar_lanterna" in player:
		player.pode_usar_lanterna = false 
		if player.lanterna: 
			player.lanterna.enabled = false
		if player.luz_circulo: 
			player.luz_circulo.enabled = false

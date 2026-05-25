extends Node2D
@export var som_da_floresta: AudioStream
@export var tempo_de_fade: float = 2.0


func _ready():
	MissaoManager.carregar_missao_do_save_atual()
	if som_da_floresta != null:
		AudioManager.tocar_ambiente(som_da_floresta, 1.0, "SFX")
	AudioManager.parar_musica(1.5)
		
		
	var player = get_tree().current_scene.find_child("Player", true, false)
	if player and "pode_usar_lanterna" in player:
		player.pode_usar_lanterna = false 
		if player.lanterna: 
			player.lanterna.enabled = false
		if player.luz_circulo: 
			player.luz_circulo.enabled = false
		
	
	
func escurecer_e_mudar_cena(caminho_cena: String):
	await FadeGlobal.fade_out(1.0)
	get_tree().change_scene_to_file(caminho_cena)

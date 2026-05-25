extends Node2D
@export var som_da_floresta: AudioStream 
@export var tempo_mostrando_imagem: float = 3.0 
@onready var cenario_real = $CenarioReal

func _ready():
	cenario_real.visible = true
	
	
	if som_da_floresta != null:
		AudioManager.tocar_ambiente(som_da_floresta, 1.0, "SFX")
	AudioManager.parar_musica(1.5)
	
	MissaoManager.carregar_missao_do_save_atual()
	
	if SaveManager.dados_atuais != null and SaveManager.dados_atuais.ja_ligou_pra_mae == true:
		TelaInventario.inventario_bloqueado = false
		var player = get_tree().current_scene.find_child("Player", true, false)
		if player:
			player.pode_usar_lanterna = false
		return 
	
	TelaInventario.inventario_bloqueado = true
	await get_tree().create_timer(1.0).timeout 
	

	if SaveManager.dados_atuais != null:
		var nome = SaveManager.dados_atuais.nome_personagem
		var foto = SaveManager.dados_atuais.foto_personagem
		var falas = [
			"Não, não, não! Meu ônibus!!", 
			"Ele foi embora e me deixou aqui no escuro..."
		]
		
		CaixaDialogoGlobal.iniciar_dialogo(falas, nome, foto)
		
		await CaixaDialogoGlobal.dialogo_terminou
	
	
	print("Cutscene terminada! Gameplay iniciado no estacionamento.")
	TelaInventario.inventario_bloqueado = false
	
	MissaoManager.definir_objetivo_por_id("estacionamento")
	
	var player = get_tree().current_scene.find_child("Player", true, false)
	if player:
		player.pode_usar_lanterna = false 
		
		if player.lanterna: player.lanterna.enabled = false
		if player.luz_circulo: player.luz_circulo.enabled = false

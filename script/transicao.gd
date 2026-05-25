extends Area2D


@export_group("Configuração do Destino")
@export_file("*.tscn") var cena_destino: String
@export var nome_do_spawn_destino: String = "SpawnPadrao" 

@export_group("Restrição de Gênero")
@export_enum("nenhum", "menino", "menina") var genero_permitido: String = "nenhum"
@export_multiline var frases_genero_negado: Array[String] = ["Humm... eu não deveria entrar aí."]

@export_group("Restrição de Item")
@export var precisa_de_item: bool = false
@export var id_do_item_necessario: String = ""
@export_multiline var frases_item_negado: Array[String] = ["Está trancada. Preciso de uma chave."]



var player_perto = false
var em_transicao = false 
var player_node = null 

func _unhandled_input(event):
	
	if player_perto and event.is_action_pressed("interagir") and not em_transicao:
		get_viewport().set_input_as_handled() 
		verificar_entrada()

func verificar_entrada():
	
	if SaveManager.dados_atuais == null:
		fazer_transicao() 
		return

	var nome_pc = SaveManager.dados_atuais.nome_personagem
	var foto_pc = SaveManager.dados_atuais.foto_personagem


	if genero_permitido != "nenhum":
		var genero_atual = SaveManager.dados_atuais.genero
		if genero_atual != genero_permitido:
			CaixaDialogoGlobal.iniciar_dialogo(frases_genero_negado, nome_pc, foto_pc)
			return 

	
	if precisa_de_item and id_do_item_necessario != "":
		# Supomos que seu SaveManager tenha a lista 'itens_no_bolso' (Array de Strings com IDs)
		# Se não tiver, ajuste para onde você guarda o inventário no save.
		var inventario = SaveManager.dados_atuais.itens_no_bolso
		
		if not inventario.has(id_do_item_necessario):
			CaixaDialogoGlobal.iniciar_dialogo(frases_item_negado, nome_pc, foto_pc)
			return 

	fazer_transicao()

func fazer_transicao():
	if cena_destino == "":
		print("Aviso: Porta sem cena de destino definida.")
		return
		
	em_transicao = true 
	
	
	if player_node and player_node.has_method("mostrar_aviso"):
		player_node.mostrar_aviso(false)
	
	await FadeGlobal.fade_out(0.8)
	
	SaveManager.alvo_spawn = nome_do_spawn_destino
	SaveManager.dados_atuais.cena_atual = cena_destino
	

	get_tree().change_scene_to_file(cena_destino)
	FadeGlobal.fade_in(0.8)



func _on_body_entered(body):
	if body.name == "Player":
		player_perto = true
		player_node = body
		
		
		if not em_transicao and body.has_method("mostrar_aviso"):
			body.mostrar_aviso(true)

func _on_body_exited(body):
	if body.name == "Player":
		player_perto = false
		
		if body.has_method("mostrar_aviso"):
			body.mostrar_aviso(false)
			
		player_node = null

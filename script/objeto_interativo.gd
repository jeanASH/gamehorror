extends Area2D

@export_category("Configuração do Diálogo")
@export var pensamento: bool = false
@export var nome_personagem: String = "Desconhecido"
@export var foto_personagem: Texture2D


@export_group("Textos e Falas")
@export var falas_diferentes_por_genero: bool = false
@export_multiline var frases_padrao: Array[String] = [""]
@export_multiline var frases_menino: Array[String] = [""]
@export_multiline var frases_menina: Array[String] = [""]

var player_perto: bool = false
var player_node = null 

func _unhandled_input(event):
	if player_perto and event.is_action_pressed("interagir"):
		disparar_dialogo()

func disparar_dialogo():
	
	if player_node and player_node.has_method("mostrar_aviso"):
		player_node.mostrar_aviso(false)
		
	
	var frases_finais = frases_padrao
	
	
	if falas_diferentes_por_genero and SaveManager.dados_atuais != null:
		var genero = SaveManager.dados_atuais.genero
		if genero == "menino":
			frases_finais = frases_menino
		elif genero == "menina":
			frases_finais = frases_menina
			
	
	if pensamento:
		var nome = SaveManager.dados_atuais.nome_personagem
		var foto = SaveManager.dados_atuais.foto_personagem
		CaixaDialogoGlobal.iniciar_dialogo(frases_finais, nome, foto)
	else:
		CaixaDialogoGlobal.iniciar_dialogo(frases_finais, nome_personagem, foto_personagem)


func _on_body_entered(body):
	if body.name == "Player":
		player_perto = true
		player_node = body
		
		
		if body.has_method("mostrar_aviso"):
			body.mostrar_aviso(true)

func _on_body_exited(body):
	if body.name == "Player":
		player_perto = false
		
		
		if body.has_method("mostrar_aviso"):
			body.mostrar_aviso(false)
			
		player_node = null

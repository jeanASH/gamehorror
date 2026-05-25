@tool
extends Area2D

@export_category("Dados do Item")
@export var id_unico_do_item: String = "id_item_01" 
@export var nome_no_inventario: String = "Novo Item"

@export_category("Visual do Item")
@export var imagem_do_item: Texture2D:
	set(nova_imagem):
		imagem_do_item = nova_imagem
		if is_node_ready() and has_node("Sprite2D"):
			$Sprite2D.texture = imagem_do_item

@export var tamanho_da_imagem: Vector2 = Vector2(1.0, 1.0):
	set(novo_tamanho):
		tamanho_da_imagem = novo_tamanho
		if is_node_ready() and has_node("Sprite2D"):
			$Sprite2D.scale = tamanho_da_imagem

@export_category("Mensagem")
@export_multiline var frases_ao_pegar: Array[String] = []

var player_perto: bool = false
var player_node = null

func _ready():
	if Engine.is_editor_hint():
		return 
	
	$Sprite2D.texture = imagem_do_item
	$Sprite2D.scale = tamanho_da_imagem
	
	if SaveManager.dados_atuais.itens_pegos_no_mapa.has(id_unico_do_item):
		queue_free()


func _unhandled_input(event):
	if Engine.is_editor_hint(): return
	
	if player_perto and event.is_action_pressed("interagir"):
		get_viewport().set_input_as_handled() 
		pegar_item()

func pegar_item():
	SaveManager.dados_atuais.itens_no_bolso.append(nome_no_inventario)
	SaveManager.dados_atuais.itens_pegos_no_mapa.append(id_unico_do_item)
	
	if player_node and player_node.has_method("mostrar_aviso"):
		player_node.mostrar_aviso(false)
		
	var falas = frases_ao_pegar
	
	if falas.size() == 0:
		falas = ["Você encontrou: " + nome_no_inventario]
		
	CaixaDialogoGlobal.iniciar_dialogo(falas)
		
	queue_free()

func _on_body_entered(body):
	if Engine.is_editor_hint(): return
	
	if body.name == "Player":
		player_perto = true
		player_node = body
		
		if body.has_method("mostrar_aviso"):
			body.mostrar_aviso(true)

func _on_body_exited(body):
	if Engine.is_editor_hint(): return
	
	if body.name == "Player":
		player_perto = false

		if body.has_method("mostrar_aviso"):
			body.mostrar_aviso(false)
			
		player_node = null

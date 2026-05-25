extends Area2D

@export_group("Configuração da Escavação")
@export var id_ferramenta_necessaria: String = "pa"
@export var id_item_ganho: String = "sapato_ana"
@export var nome_item_ganho: String = "Sapato da Ana"

var player_perto: bool = false
var ja_cavou: bool = false
var player_node = null

func _ready():
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _unhandled_input(event):
	if Engine.is_editor_hint(): return
	
	if player_perto and event.is_action_pressed("interagir") and not ja_cavou:
		get_viewport().set_input_as_handled()
		cavar()

func cavar():
	var inventario = SaveManager.dados_atuais.itens_no_bolso
	
	if inventario.has(id_ferramenta_necessaria):
		ja_cavou = true
		
		inventario.append(id_item_ganho)
		
		 #$Sprite2D.visible = false 
		if player_node and player_node.has_method("mostrar_aviso"):
			player_node.mostrar_aviso(false)
		
		CaixaDialogoGlobal.iniciar_dialogo([
			"Você usou a pá para afastar a terra fofa...",
			"Havia algo enterrado aqui!",
			"Você encontrou: " + nome_item_ganho + "."
		])
		
	else:
		CaixaDialogoGlobal.iniciar_dialogo([
			"A terra aqui parece ter sido mexida recentemente.",
			"Se eu tivesse alguma ferramenta para cavar, talvez pudesse ver o que tem embaixo..."
		])


func _on_body_entered(body):
	if Engine.is_editor_hint(): return
	
	if body.name == "Player":
		player_perto = true
		player_node = body
		
		if not ja_cavou and body.has_method("mostrar_aviso"):
			body.mostrar_aviso(true)

func _on_body_exited(body):
	if Engine.is_editor_hint(): return
	
	if body.name == "Player":
		player_perto = false
		
		if body.has_method("mostrar_aviso"):
			body.mostrar_aviso(false)
			
		player_node = null

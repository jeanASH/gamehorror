extends Area2D

@export_group("Configuração do Ritual")
@export var id_item_necessario: String = ""
@export var nome_item_amigavel: String = "Item"

@onready var sprite_item = $SpriteItem
var id_unico_pilar: String = "pilar_1"

var player_perto: bool = false
var pilar_resolvido: bool = false

func _ready():
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	
	if SaveManager.dados_atuais.pilares_resolvidos.has(id_unico_pilar):
		pilar_resolvido = true
		if sprite_item:
			sprite_item.visible = true
	else:
		pilar_resolvido = false
		if sprite_item:
			sprite_item.visible = false


func _unhandled_input(event):
	if player_perto and event.is_action_pressed("interagir"):
		get_viewport().set_input_as_handled()
		interagir()

func interagir():
	if pilar_resolvido:
		CaixaDialogoGlobal.iniciar_dialogo(["O " + nome_item_amigavel + " já está posicionado aqui."])
		return
	
	var inventario = SaveManager.dados_atuais.itens_no_bolso
	
	if inventario.has(id_item_necessario):
		inventario.erase(id_item_necessario)
		$grito.play()
		
		if sprite_item:
			sprite_item.visible = true
			
		pilar_resolvido = true
		SaveManager.dados_atuais.pilares_resolvidos.append(id_unico_pilar)
		SaveManager.salvar_jogo()
		
		CaixaDialogoGlobal.iniciar_dialogo(["Você colocou o " + nome_item_amigavel + " no pedestal."])
		

		if SaveManager.dados_atuais.pilares_resolvidos.size() == 4:
			await get_tree().create_timer(4.0).timeout
			
			get_tree().paused = false
			
			get_tree().change_scene_to_file("res://scenes/levels/telafinal.tscn")
		
	else:
		CaixaDialogoGlobal.iniciar_dialogo(["Placa: 'Espaço para um laço perdido'"])



func _on_body_entered(body):
	if Engine.is_editor_hint(): return
	
	if body.name == "Player":
		player_perto = true
		
		if body.has_method("mostrar_aviso"):
			body.mostrar_aviso(true)

func _on_body_exited(body):
	if Engine.is_editor_hint(): return
	
	if body.name == "Player":
		player_perto = false

		if body.has_method("mostrar_aviso"):
			body.mostrar_aviso(false)

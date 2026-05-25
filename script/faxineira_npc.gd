extends Area2D

@export var foto_faxineira: Texture2D
@onready var papel_item_base = $"../PapelNoChao"

var ja_interagiu: bool = false

func _ready():
	body_entered.connect(_on_body_entered)

	if SaveManager.dados_atuais != null and SaveManager.dados_atuais.encontrou_faxineira == true:
		if papel_item_base:
			if not SaveManager.dados_atuais.itens_no_bolso.has("papel"):
				papel_item_base.visible = true
				papel_item_base.process_mode = Node.PROCESS_MODE_INHERIT
		queue_free()
		return

	if papel_item_base:
		papel_item_base.visible = false
		papel_item_base.process_mode = Node.PROCESS_MODE_DISABLED


func _on_body_entered(body):
	if body.name == "Player" and not ja_interagiu:
		interagir()

func interagir():
	if ja_interagiu: return
	ja_interagiu = true
	
	TelaInventario.inventario_bloqueado = true
	
	var nome_player = SaveManager.dados_atuais.nome_personagem
	var foto_player = SaveManager.dados_atuais.foto_personagem
	
	var conversa = [
		{"nome": "Faxineira", "texto": "O que ainda está fazendo aqui na escola? Já fechou faz tempo...", "foto": foto_faxineira},
		{"nome": nome_player, "texto": "Estou esperando meus pais virem me buscar... O ônibus foi embora e me deixou aqui.", "foto": foto_player},
		{"nome": "Faxineira", "texto": "Ah, entendi... Que situação complicada. Eu ainda estou terminando o meu turno por aqui, as coisas estão bem bagunçadas...", "foto": foto_faxineira},
		{"nome": "Faxineira", "texto": "Nossa, tenho que arrumar a biblioteca depois... Está imundo lá dentro, até tinta derramaram no chão? Como conseguem fazer isso?...", "foto": foto_faxineira},
		{"nome": "Faxineira", "texto": "Desculpa mas vou limpar outro local, pode se sentir a vontade...", "foto": foto_faxineira}
	]
	
	CaixaDialogoGlobal.iniciar_conversa(conversa)
	await CaixaDialogoGlobal.dialogo_terminou
	
	await FadeGlobal.fade_out(1.0)
	
	if SaveManager.dados_atuais != null:
		SaveManager.dados_atuais.encontrou_faxineira = true
	
	if papel_item_base:
		papel_item_base.process_mode = Node.PROCESS_MODE_INHERIT
		papel_item_base.visible = true
	
	visible = false
	
	await get_tree().create_timer(0.6).timeout
	await FadeGlobal.fade_in(1.0)
	
	TelaInventario.inventario_bloqueado = false
	MissaoManager.definir_objetivo_por_id("investigar_biblioteca")
	
	queue_free()

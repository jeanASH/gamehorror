extends CanvasLayer

@onready var grid_mochila = $GridContainer
@onready var caixa_descricao = $CaixaDescricao
@onready var nome_item_label = $CaixaDescricao/NomeItemLabel
@onready var texto_item_label = $CaixaDescricao/TextoItemLabel

# Referências da Nota
@onready var exame_nota_ui = $ExameNotaUI
@onready var imagem_nota = $ExameNotaUI/ImagemNota

var inventario_bloqueado: bool = false 

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	visible = false 
	exame_nota_ui.visible = false
	limpar_descricao()

func _input(event):
	if exame_nota_ui.visible:
		var apertou_esc = event.is_action_pressed("ui_cancel")
		var clicou_mouse = event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT
		
		if apertou_esc or clicou_mouse:
			fechar_exame_nota()
			get_viewport().set_input_as_handled()
			return

	if inventario_bloqueado: return
	if CaixaDialogoGlobal.painel_fundo.visible: return
		
	if get_tree().current_scene != null:
		var cenas_proibidas = ["MenuPrincipal", "SelecaoSave", "transicao","SelecaoPersonagem","Introbus","PauseMenu"]
		if get_tree().current_scene.name in cenas_proibidas:
			return

	# ==========================================
	# ABRIR / FECHAR INVENTÁRIO (TAB)
	# ==========================================
	if event.is_action_pressed("abrir_inventario"):
		# Se a nota estiver aberta, o TAB fecha tudo de uma vez
		if exame_nota_ui.visible:
			exame_nota_ui.visible = false
			visible = false
			get_tree().paused = false
		else:
			visible = !visible
			get_tree().paused = visible 
			
			if visible:
				grid_mochila.visible = true
				caixa_descricao.visible = false
				exame_nota_ui.visible = false
				atualizar_grade()
				limpar_descricao()

func atualizar_grade():
	for filho in grid_mochila.get_children():
		filho.queue_free()
		
	var inventario_do_jogador = SaveManager.dados_atuais.itens_no_bolso
	if inventario_do_jogador.size() == 0: return
		
	for nome_item in inventario_do_jogador:
		if BancoDeItens.info_itens.has(nome_item):
			var botao = TextureButton.new()
			botao.texture_normal = BancoDeItens.info_itens[nome_item]["icone"]
			botao.ignore_texture_size = true 
			botao.stretch_mode = TextureButton.STRETCH_KEEP_ASPECT_CENTERED 
			botao.custom_minimum_size = Vector2(64, 64) 
			botao.mouse_entered.connect(_mostrar_descricao.bind(nome_item))
			botao.mouse_exited.connect(limpar_descricao)
			botao.pressed.connect(_ao_usar_item.bind(nome_item))
			grid_mochila.add_child(botao)

func _mostrar_descricao(nome_do_item: String):
	if not exame_nota_ui.visible: 
		caixa_descricao.visible = true
		nome_item_label.text = nome_do_item
		texto_item_label.text = BancoDeItens.info_itens[nome_do_item]["descricao"]

func limpar_descricao():
	caixa_descricao.visible = false

func _ao_usar_item(nome_do_item: String):
	if nome_do_item == "Celular":
		visible = false 
		get_tree().paused = false 
		iniciar_ligacao_mae()
	
	elif nome_do_item == "papel":
		abrir_exame_nota()

# ==========================================
# FUNÇÕES DA NOTA EM TELA CHEIA
# ==========================================
func abrir_exame_nota():
	grid_mochila.visible = false
	caixa_descricao.visible = false
	exame_nota_ui.visible = true

func fechar_exame_nota():
	exame_nota_ui.visible = false
	grid_mochila.visible = true


func iniciar_ligacao_mae():
	var nome_player = SaveManager.dados_atuais.nome_personagem
	var foto_player = SaveManager.dados_atuais.foto_personagem
	
	if SaveManager.dados_atuais.ja_ligou_pra_mae == false:
		var ligacao = [
			{"nome": nome_player, "texto": "Mãe? Atende, por favor...", "foto": foto_player},
			{"nome": "Mãe", "texto": "Alô? Onde você está? A ligação está péssima!", "foto": null},
			{"nome": nome_player, "texto": "Tô no ponto de ônibus, mas me esqueceram...", "foto": foto_player},
			{"nome": "Mãe", "texto": "Não sai daí! Estamos in-- *chiado*", "foto": null},
			{"nome": "", "texto": "*A ligação caiu.*", "foto": null},
			{"nome": nome_player, "texto": "Ehh acho que vou para a lanchonete esperar.", "foto": foto_player},
		]
		CaixaDialogoGlobal.iniciar_conversa(ligacao)
		
		SaveManager.dados_atuais.ja_ligou_pra_mae = true
		MissaoManager.definir_objetivo_por_id("lanchonete_explorar")
		

	elif SaveManager.dados_atuais.terceira_vez == false:
		var sem_sinal = [
			{"nome": "", "texto": "     *Tu... Tu... Tu... Fora de área de cobertura.*", "foto": null},
			{"nome": nome_player, "texto": "Droga... O sinal morreu completamente.", "foto": foto_player}
		]
		CaixaDialogoGlobal.iniciar_conversa(sem_sinal)
		
		SaveManager.dados_atuais.terceira_vez = true

	else:
		var silencio = [
			{"nome": "", "texto": "                                    ...", "foto": null}
		]
		CaixaDialogoGlobal.iniciar_conversa(silencio)

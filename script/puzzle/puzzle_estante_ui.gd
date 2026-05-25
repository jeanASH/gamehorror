extends CanvasLayer

@onready var container_livros = $HBoxContainer
var livro_selecionado = null

func _ready():
	visible = false 
	process_mode = Node.PROCESS_MODE_ALWAYS 
	
	for livro in container_livros.get_children():
		if livro is TextureButton:
			livro.pressed.connect(_ao_clicar_no_livro.bind(livro))

func _input(event):
	if visible and event.is_action_pressed("ui_cancel"):
		get_viewport().set_input_as_handled() 
		fechar_puzzle()

func _ao_clicar_no_livro(livro_clicado):
	if livro_selecionado == null:
		livro_selecionado = livro_clicado
		livro_selecionado.modulate = Color(0.5, 0.5, 0.5) 
	
	elif livro_selecionado == livro_clicado:
		livro_selecionado.modulate = Color(1, 1, 1)
		livro_selecionado = null
		
	else:
		var index_original = livro_selecionado.get_index()
		var index_destino = livro_clicado.get_index()
		
		container_livros.move_child(livro_selecionado, index_destino)
		container_livros.move_child(livro_clicado, index_original)
		
		livro_selecionado.modulate = Color(1, 1, 1)
		livro_selecionado = null
		
		verificar_vitoria()

func verificar_vitoria():
	var ordem_atual = []
	for livro in container_livros.get_children():
		ordem_atual.append(str(livro.name))
	
	var vitoria = ["1", "2", "3", "4", "5", "6", "7"]
	
	if ordem_atual == vitoria:
		print("Puzzle resolvido!")
		if SaveManager.dados_atuais != null:
			SaveManager.dados_atuais.puzzle_estante_resolvido = true 
			
			var item_ganho = "Chave" 
			if not SaveManager.dados_atuais.itens_no_bolso.has(item_ganho):
				SaveManager.dados_atuais.itens_no_bolso.append(item_ganho)
		

		await get_tree().create_timer(0.6).timeout
		fechar_puzzle()
		
		var nome_player = SaveManager.dados_atuais.nome_personagem
		var foto_player = SaveManager.dados_atuais.foto_personagem
		
		var dialogo_vitoria = [
			{
				"nome": nome_player, 
				"texto": "Tinha uma chave atrás dos livros?", 
				"foto": foto_player
			}
		]
		
		CaixaDialogoGlobal.iniciar_conversa(dialogo_vitoria)
		MissaoManager.definir_objetivo_por_id("procurar")

func abrir_puzzle():
	visible = true
	get_tree().paused = true 

func fechar_puzzle():
	visible = false
	get_tree().paused = false 

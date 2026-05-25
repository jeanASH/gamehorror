extends CanvasLayer

func _ready():
	hide()
	TelaInventario.inventario_bloqueado = false
	
	if has_node("PainelOpcoes"):
		$PainelOpcoes.visible = false
		
	$BotoesPrincipais/Opcoes.pressed.connect(_abrir_opcoes)
	$PainelOpcoes/BtnVoltar.pressed.connect(_fechar_opcoes)
	$PainelOpcoes/CheckButton.toggled.connect(_ao_mudar_tela_cheia)
	

	$PainelOpcoes/Master.value_changed.connect(_ao_mudar_volume_geral)
	$PainelOpcoes/Musica.value_changed.connect(_ao_mudar_volume_musica)
	$PainelOpcoes/SFX.value_changed.connect(_ao_mudar_volume_sfx)
	$PainelOpcoes/UI.value_changed.connect(_ao_mudar_volume_ui)

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		if TelaInventario.visible == true:
			TelaInventario.visible = false
			get_tree().paused = false
			return 
			
		if get_tree().current_scene != null:
			var cenas_proibidas = ["MenuPrincipal", "SelecaoSave", "transicao", "SelecaoPersonagem", "TelaInventario"]
			if get_tree().current_scene.name in cenas_proibidas:
				return
				
		toggle_pause()

func toggle_pause():
	var new_pause_state = !get_tree().paused
	get_tree().paused = new_pause_state
	visible = new_pause_state 
	TelaInventario.inventario_bloqueado = new_pause_state
	
	if visible:
		$BotoesPrincipais.visible = true
		$PainelOpcoes.visible = false
		sincronizar_interface_opcoes()

func sincronizar_interface_opcoes():
	var tela_cheia = DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN
	$PainelOpcoes/CheckButton.button_pressed = tela_cheia
	
	var db_master = AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Master"))
	$PainelOpcoes/Master.value = db_to_linear(db_master)
	
	var db_musica = AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Musica"))
	$PainelOpcoes/Musica.value = db_to_linear(db_musica)
	
	var db_sfx = AudioServer.get_bus_volume_db(AudioServer.get_bus_index("SFX"))
	$PainelOpcoes/SFX.value = db_to_linear(db_sfx)
	
	var db_ui = AudioServer.get_bus_volume_db(AudioServer.get_bus_index("UI"))
	$PainelOpcoes/UI.value = db_to_linear(db_ui)

func _abrir_opcoes():
	# $SomClique.play() 
	$BotoesPrincipais.visible = false
	$PainelOpcoes.visible = true
	
func _fechar_opcoes():
	var vol_master = $PainelOpcoes/Master.value
	var vol_musica = $PainelOpcoes/Musica.value
	var vol_sfx = $PainelOpcoes/SFX.value
	var vol_ui = $PainelOpcoes/UI.value
	var tela_cheia_atual = $PainelOpcoes/CheckButton.button_pressed
	
	ConfigManager.salvar_configuracoes(vol_master, vol_musica, vol_sfx, vol_ui, tela_cheia_atual)

	# $SomClique.play() 
	$PainelOpcoes.visible = false
	$BotoesPrincipais.visible = true


func _ao_mudar_tela_cheia(ativado):
	if ativado:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)

func _ao_mudar_volume_geral(valor):
	var bus_index = AudioServer.get_bus_index("Master")
	AudioServer.set_bus_volume_db(bus_index, linear_to_db(valor))

func _ao_mudar_volume_musica(valor):
	var bus_index = AudioServer.get_bus_index("Musica")
	AudioServer.set_bus_volume_db(bus_index, linear_to_db(valor))

func _ao_mudar_volume_sfx(valor):
	var bus_index = AudioServer.get_bus_index("SFX")
	AudioServer.set_bus_volume_db(bus_index, linear_to_db(valor))

func _ao_mudar_volume_ui(valor):
	var bus_index = AudioServer.get_bus_index("UI")
	AudioServer.set_bus_volume_db(bus_index, linear_to_db(valor))


func _on_continuar_pressed():
	toggle_pause() 

func _on_sair_pressed():
	AudioManager.parar_ambiente(1.5)
	AudioManager.parar_musica(1.5)
	toggle_pause()
	get_tree().paused = false 
	hide()
	get_tree().change_scene_to_file("res://scenes/ui/menu_principal.tscn")

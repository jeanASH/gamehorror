extends Control
@export var musica_da_cena: AudioStream
@export var tempo_de_fade: float = 2.0

var intensidade = 0.6

func _ready():
	FadeGlobal.fade_in(1.0)
	if musica_da_cena:
		AudioManager.tocar_musica(musica_da_cena, tempo_de_fade, "UI")
	

	for botao in $BotoesPrincipais.get_children():
		if botao is Button:
			botao.mouse_entered.connect(_ao_passar_o_mouse.bind(botao))
			
	$BotoesPrincipais/Sair.pressed.connect(_ao_clicar_sair)
	$"BotoesPrincipais/Jogar".pressed.connect(_ao_clicar_novo_jogo)
	$"BotoesPrincipais/Opções".pressed.connect(_abrir_opcoes)
	
	
	$PainelOpcoes/BtnVoltar.pressed.connect(_fechar_opcoes)
	$PainelOpcoes/CheckButton.toggled.connect(_ao_mudar_tela_cheia)
	

	$PainelOpcoes/Master.value_changed.connect(_ao_mudar_volume_geral)
	$PainelOpcoes/Musica.value_changed.connect(_ao_mudar_volume_musica)
	$PainelOpcoes/SFX.value_changed.connect(_ao_mudar_volume_sfx)
	$PainelOpcoes/UI.value_changed.connect(_ao_mudar_volume_ui)
	

	var tela_cheia = DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN
	
	$PainelOpcoes/CheckButton.set_pressed_no_signal(tela_cheia)
	
	var db_master = AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Master"))
	$PainelOpcoes/Master.set_value_no_signal(db_to_linear(db_master))
	
	var db_musica = AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Musica"))
	$PainelOpcoes/Musica.set_value_no_signal(db_to_linear(db_musica))
	
	var db_sfx = AudioServer.get_bus_volume_db(AudioServer.get_bus_index("SFX"))
	$PainelOpcoes/SFX.set_value_no_signal(db_to_linear(db_sfx))
	
	var db_ui = AudioServer.get_bus_volume_db(AudioServer.get_bus_index("UI"))
	$PainelOpcoes/UI.set_value_no_signal(db_to_linear(db_ui))
	
func _abrir_opcoes():
	$SomClique.play()
	$BotoesPrincipais.visible = false
	$PainelOpcoes.visible = true
	
func _fechar_opcoes():

	var vol_master = $PainelOpcoes/Master.value
	var vol_musica = $PainelOpcoes/Musica.value
	var vol_sfx = $PainelOpcoes/SFX.value
	var vol_ui = $PainelOpcoes/UI.value
	var tela_cheia_atual = $PainelOpcoes/CheckButton.button_pressed
	
	ConfigManager.salvar_configuracoes(vol_master, vol_musica, vol_sfx, vol_ui, tela_cheia_atual)
	
	$SomClique.play()
	$PainelOpcoes.visible = false
	$BotoesPrincipais.visible = true
			
func _ao_clicar_sair():
	$SomClique.play()
	await FadeGlobal.fade_out(1.5)
	get_tree().quit()
	
func _ao_clicar_novo_jogo():
	$SomClique.play() 
	FadeGlobal.fade_in(2.0)
	get_tree().change_scene_to_file("res://scenes/ui/selecao_save.tscn")

func _process(_delta):
	for botao in $PainelOpcoes.get_children():
		if botao is Button and botao.is_hovered():
			botao.position += Vector2(randf_range(-intensidade, intensidade), randf_range(-intensidade, intensidade))

	for botao in $BotoesPrincipais.get_children():
		if botao is Button and botao.is_hovered():
			botao.position += Vector2(randf_range(-intensidade, intensidade), randf_range(-intensidade, intensidade))

func _ao_passar_o_mouse(botao):
	botao.modulate = Color(1.5, 1.5, 1.5) 

# --- FUNÇÕES DE VOLUME ---

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

func _ao_mudar_tela_cheia(ativado):
	if ativado:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)

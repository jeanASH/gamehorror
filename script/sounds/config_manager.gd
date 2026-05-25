extends Node

var config = ConfigFile.new()
var caminho_arquivo = "user://settings.cfg"

func _ready():
	print("--- INICIANDO CONFIG MANAGER ---")
	carregar_configuracoes()

func salvar_configuracoes(vol_master: float, vol_musica: float, vol_sfx: float, vol_ui: float, tela_cheia: bool):
	print("TENTANDO SALVAR: Master=", vol_master, " Musica=", vol_musica, " SFX=", vol_sfx, " UI=", vol_ui)
	
	config.set_value("Audio", "volume_master", vol_master)
	config.set_value("Audio", "volume_musica", vol_musica)
	config.set_value("Audio", "volume_sfx", vol_sfx)
	config.set_value("Audio", "volume_ui", vol_ui)
	config.set_value("Video", "tela_cheia", tela_cheia)
	
	var erro = config.save(caminho_arquivo)
	if erro == OK:
		print("✅ SALVOU COM SUCESSO NO ARQUIVO!")
	else:
		print("❌ ERRO AO SALVAR! Código do erro: ", erro)

func carregar_configuracoes():
	var erro = config.load(caminho_arquivo)
	if erro == OK:
		print("✅ ARQUIVO ENCONTRADO! Carregando...")
		
		var vol_master = config.get_value("Audio", "volume_master", 1.0)
		var vol_musica = config.get_value("Audio", "volume_musica", 1.0)
		var vol_sfx = config.get_value("Audio", "volume_sfx", 1.0)
		var vol_ui = config.get_value("Audio", "volume_ui", 1.0)
		
		print("VALORES LIDOS DO ARQUIVO: Master=", vol_master, " Musica=", vol_musica, " SFX=", vol_sfx, " UI=", vol_ui)
		
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), linear_to_db(vol_master))
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Musica"), linear_to_db(vol_musica))
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), linear_to_db(vol_sfx))
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("UI"), linear_to_db(vol_ui))
		
		var tela_cheia_salva = config.get_value("Video", "tela_cheia", false)
		if tela_cheia_salva:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		else:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	else:
		print("⚠️ NENHUM ARQUIVO DE SAVE ENCONTRADO OU ERRO AO LER. Código: ", erro)

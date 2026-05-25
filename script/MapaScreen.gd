extends Control


@onready var biblioteca_button = $PontosParent/PontoBiblioteca/BibliotecaBotao
@onready var estacionamento_button = $PontosParent/PontoEstacionamento/EstacionamentoBotao
@onready var laboratorio_button = $PontosParent/PontoLaboratorio/LaboratorioBotao
@onready var lanchonete_button = $PontosParent/PontoLanchonete/LanchoneteBotao

const BIBLIOTECA_SCENE = "res://scenes/levels/BibliotecaExterior.tscn"
const ESTACIONAMENTO_SCENE = "res://scenes/levels/Estacionamento.tscn"
const LABORATORIO_SCENE = "res://scenes/levels/Olimpo.tscn"
const LANCHONETE_SCENE = "res://scenes/levels/lanchonete.tscn"

func _ready():
	MissaoManager.carregar_missao_do_save_atual()
	biblioteca_button.pressed.connect(_on_biblioteca_pressed)
	estacionamento_button.pressed.connect(_on_estacionamento_pressed)
	laboratorio_button.pressed.connect(_on_laboratorio_pressed)
	



func _on_biblioteca_pressed():
	print("Fast travel para a Biblioteca...")
	SaveManager.dados_atuais.progresso = "Biblioteca"
	viajar_para_cena(BIBLIOTECA_SCENE)

func _on_estacionamento_pressed():
	print("Fast travel para o Estacionamento...")
	SaveManager.dados_atuais.progresso = "Estacionamento"
	viajar_para_cena(ESTACIONAMENTO_SCENE)

func _on_laboratorio_pressed():
	print("Fast travel para o Laboratorio...")
	SaveManager.dados_atuais.progresso = "Laboratorio"
	viajar_para_cena(LABORATORIO_SCENE)


func viajar_para_cena(nova_cena: String):
	if nova_cena != "":
		get_tree().paused = false 
		await FadeGlobal.fade_out(0.8) 
		visible = false 
		SaveManager.dados_atuais.cena_atual = nova_cena
		SaveManager.salvar_jogo()
		get_tree().change_scene_to_file(nova_cena)
		FadeGlobal.fade_in(0.8)


func _on_lanchonete_botao_pressed():
	print("Fast travel para lanchonete...")
	SaveManager.dados_atuais.progresso= "Lanchonete"
	viajar_para_cena(LANCHONETE_SCENE)

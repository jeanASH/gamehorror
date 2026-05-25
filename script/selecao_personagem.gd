extends Control
@export var musica_da_cena: AudioStream
@export var tempo_de_fade: float = 2.0

var foto_menino = preload("res://imagens/meninogame.png") 
var foto_menina = preload("res://imagens/meninagame.png")

func _ready():
	if musica_da_cena:
		AudioManager.tocar_musica(musica_da_cena, tempo_de_fade, "UI")

func _on_botao_masculino_pressed():
	criar_novo_save("Jean", "menino", foto_menino)

func _on_botao_feminino_pressed():
	criar_novo_save("Mori", "menina", foto_menina)


func criar_novo_save(nome, genero_texto, foto):
	var novo_save = SaveGame.new()
	
	novo_save.nome_personagem = nome
	novo_save.genero = genero_texto    
	novo_save.foto_personagem = foto
	novo_save.progresso = "Estacionamento"
	novo_save.cena_atual = "res://scenes/levels/Estacionamento.tscn" 
	
	SaveManager.dados_atuais = novo_save
	SaveManager.salvar_jogo()
	
	get_tree().change_scene_to_file(novo_save.cena_atual)

extends Node2D
@export var banheiro: AudioStream

func _ready():
	MissaoManager.carregar_missao_do_save_atual()
	if banheiro != null:
		AudioManager.tocar_ambiente(banheiro, 1.0, "SFX")
	AudioManager.parar_musica(1.5)
		

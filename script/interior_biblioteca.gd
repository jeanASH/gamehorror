extends Node2D

@export var som_drone_vazio: AudioStream
@export var som_madeira_rangendo: AudioStream

@onready var timer_madeira = $TimerMadeira

func _ready():
	MissaoManager.carregar_missao_do_save_atual()
	if som_drone_vazio:
		AudioManager.tocar_ambiente(som_drone_vazio, 1.0, "SFX")
	AudioManager.parar_musica(2.0)
	
	if som_madeira_rangendo:
		timer_madeira.timeout.connect(_on_timer_madeira_timeout)
		configurar_proximo_estalo()

func configurar_proximo_estalo():
	timer_madeira.wait_time = randf_range(7.0, 18.0)
	timer_madeira.start()

func _on_timer_madeira_timeout():
	AudioManager.tocar_som(som_madeira_rangendo, "Musica")
	configurar_proximo_estalo()

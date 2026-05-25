extends Node2D

@export var sprite_olho: Texture2D 

@export_group("Configurações de Chance")
@export_range(0.0, 1.0) var chance_de_aparecer: float = 0.3 

@export_group("Configurações do Efeito")
@export var intervalo_min: float = 0.5   
@export var intervalo_max: float = 3.0   
@export var duracao_min: float = 0.1     
@export var duracao_max: float = 0.5     
@export var numero_max_olhos: int = 8    
@export var color_rect_fundo: ColorRect 

var timer_piscada: Timer
var sala_ativa: bool = false

func _ready():
	MissaoManager.carregar_missao_do_save_atual()
	var resultado_sorteio = randf()
	$vozes.play()
	
	if resultado_sorteio <= chance_de_aparecer:
		sala_ativa = true
		print("Evento Ativado: Você está sendo observado...")
	else:
		sala_ativa = false
		print("Evento Falhou: A sala parece segura desta vez.")
		return
		
	timer_piscada = Timer.new()
	add_child(timer_piscada)
	timer_piscada.one_shot = true
	timer_piscada.timeout.connect(_on_timer_piscada_timeout)
	
	_iniciar_proxima_piscada()

func _iniciar_proxima_piscada():
	if not sala_ativa: return
	
	var intervalo_aleatorio = randf_range(intervalo_min, intervalo_max)
	timer_piscada.start(intervalo_aleatorio)

func _on_timer_piscada_timeout():
	if not sala_ativa: return

	if get_child_count() > numero_max_olhos:
		_iniciar_proxima_piscada()
		return

	var novo_olho = Sprite2D.new()
	novo_olho.texture = sprite_olho
	
	var retangulo_area = color_rect_fundo.get_global_rect()
	var posicao_x = randf_range(retangulo_area.position.x, retangulo_area.end.x)
	var posicao_y = randf_range(retangulo_area.position.y, retangulo_area.end.y)
	novo_olho.global_position = Vector2(posicao_x, posicao_y)
	
	add_child(novo_olho)
	
	var duracao_aleatoria = randf_range(duracao_min, duracao_max)
	await get_tree().create_timer(duracao_aleatoria).timeout
	
	novo_olho.queue_free()
	_iniciar_proxima_piscada()

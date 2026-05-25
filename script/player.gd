extends CharacterBody2D

const SPEED = 110.0


@export var pode_usar_lanterna: bool = true
@export var cenario_referencia: Sprite2D 
@onready var anim = $Anim 
@onready var camera = $Camera2D 
@onready var aviso_interacao = $AvisoInteracao


@onready var pivo_lanterna = $PivoLanterna 
@onready var lanterna = $PivoLanterna/PointLight2D 
@onready var luz_circulo = $LuzCirculo 

#@onready var som_clique = $AudioStreamPlayer2D

var alvo_rotacao_luz: float = 0.0
@export var suavidade_lanterna: float = 15.0 

var tween_aviso: Tween
var escala_original_aviso: Vector2 = Vector2.ONE


@export_category("Efeito de Profundidade")
@export var ativar_profundidade: bool = false
@export var linha_longe_y: float = 200.0 
@export var tamanho_longe: float = 0.6    

@export var linha_perto_y: float = 600.0  
@export var tamanho_perto: float = 1.0    

func _ready():
	if aviso_interacao:
		escala_original_aviso = aviso_interacao.scale
		aviso_interacao.visible = false
		
	if SaveManager.dados_atuais != null:
		# Lógica de Gênero
		if SaveManager.dados_atuais.genero == "menina":
			anim.sprite_frames = preload("res://assets/sprites/anim_menina.tres")
			anim.scale = Vector2(0.04, 0.04) 
		elif SaveManager.dados_atuais.genero == "menino":
			anim.sprite_frames = preload("res://assets/sprites/anim_menino.tres")
			anim.scale = Vector2(0.04, 0.04) 
		

		if lanterna:
			lanterna.enabled = false
		if luz_circulo:
			luz_circulo.enabled = false
		SaveManager.dados_atuais.lanterna_ligada = false
		
		anim.play("idle")
	
	if SaveManager.alvo_spawn != "":
		var ponto_nascimento = get_tree().current_scene.find_child(SaveManager.alvo_spawn, true, false)
		if ponto_nascimento != null:
			global_position = ponto_nascimento.global_position
			
	SaveManager.alvo_spawn = ""
	
	configurar_limites_camera()


func _input(event):
	if event.is_action_pressed("ui_flashlight") or (event is InputEventKey and event.pressed and event.keycode == KEY_F):
		if pode_usar_lanterna == false:
			return
			
		if lanterna:
			lanterna.enabled = !lanterna.enabled
			
			if luz_circulo:
				luz_circulo.enabled = lanterna.enabled
			if SaveManager.dados_atuais != null:
				SaveManager.dados_atuais.lanterna_ligada = lanterna.enabled

func configurar_limites_camera():
	if cenario_referencia and camera:
		var rect = cenario_referencia.get_rect()
		var escala = cenario_referencia.global_scale
		var pos = cenario_referencia.global_position

		camera.limit_left = pos.x - (rect.size.x / 2) * escala.x
		camera.limit_top = pos.y - (rect.size.y / 2) * escala.y
		camera.limit_right = pos.x + (rect.size.x / 2) * escala.x
		camera.limit_bottom = pos.y + (rect.size.y / 2) * escala.y

func _physics_process(_delta):
	if get_tree().paused:
		if anim.is_playing():
			anim.stop()
		return

	var direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	
	if direction != Vector2.ZERO:
		velocity = direction * SPEED
		
		if direction.x != 0:
			anim.play("walk") 
			anim.flip_h = direction.x < 0
			alvo_rotacao_luz = deg_to_rad(180) if direction.x < 0 else deg_to_rad(0)
				
		elif direction.y < 0:
			anim.play("walk_up")
			alvo_rotacao_luz = deg_to_rad(-90)
				
		elif direction.y > 0:
			anim.play("walk_down")
			alvo_rotacao_luz = deg_to_rad(90)
		
		ajustar_escala_genero(true)
			
	else:
		velocity = velocity.move_toward(Vector2.ZERO, SPEED)
		anim.play("idle")
		ajustar_escala_genero(false)

	if pivo_lanterna:
		pivo_lanterna.rotation = lerp_angle(pivo_lanterna.rotation, alvo_rotacao_luz, suavidade_lanterna * _delta)

	move_and_slide()
	
	if ativar_profundidade == true:
		var escala_calculada = remap(global_position.y, linha_longe_y, linha_perto_y, tamanho_longe, tamanho_perto)
		escala_calculada = clamp(escala_calculada, tamanho_longe, tamanho_perto)
		scale = Vector2(escala_calculada, escala_calculada)

# ==========================================
# SISTEMA DE AVISO DE INTERAÇÃO (PULSAÇÃO)
# ==========================================
func mostrar_aviso(mostrar: bool):
	if aviso_interacao:
		aviso_interacao.visible = mostrar
		
		if mostrar:
			if tween_aviso and tween_aviso.is_valid():
				tween_aviso.kill()
			
			aviso_interacao.scale = escala_original_aviso
			
			tween_aviso = create_tween().set_loops()
			tween_aviso.tween_property(aviso_interacao, "scale", escala_original_aviso * 1.2, 0.5).set_trans(Tween.TRANS_SINE)
			tween_aviso.tween_property(aviso_interacao, "scale", escala_original_aviso, 0.5).set_trans(Tween.TRANS_SINE)
		else:
			if tween_aviso and tween_aviso.is_valid():
				tween_aviso.kill()

func ajustar_escala_genero(em_movimento: bool):
	if SaveManager.dados_atuais == null: return
	
	var genero = SaveManager.dados_atuais.genero
	

extends CanvasLayer

signal dialogo_terminou

@onready var painel_fundo = $PainelFundo
@onready var nome_label = $PainelFundo/NomeLabel
@onready var texto_label = $PainelFundo/TextoLabel
@onready var icone_continuar = $PainelFundo/IconeContinuar
@onready var retrato = $PainelFundo/Retrato

# --- NÓS DO SISTEMA DE SOM ---
@onready var som_digitacao = $SomDigitacao
@onready var timer_digitacao = $TimerDigitacao

var conversa_atual: Array = [] 
var linha_atual: int = 0
var escrevendo: bool = false
var tween_texto: Tween

func _ready():
	painel_fundo.visible = false
	

	if timer_digitacao:
		timer_digitacao.timeout.connect(_tocar_som_letra)

# --- FUNÇÃO QUE TOCA O BIPE ---
func _tocar_som_letra():
	if som_digitacao:
		som_digitacao.play()

func iniciar_dialogo(linhas: Array, nome_personagem: String = "", foto: Texture2D = null):
	if linhas.size() == 0:
		return
	
	var falas_convertidas = []
	for frase in linhas:
		falas_convertidas.append({
			"nome": nome_personagem,
			"texto": frase,
			"foto": foto
		})
	
	iniciar_conversa(falas_convertidas)

func iniciar_conversa(falas: Array):
	if falas.size() == 0:
		return
		
	conversa_atual = falas
	linha_atual = 0
	painel_fundo.visible = true
	get_tree().paused = true
	
	mostrar_linha_atual()

func mostrar_linha_atual():
	var fala = conversa_atual[linha_atual]
	
	if fala.has("nome") and fala["nome"] != "":
		nome_label.visible = true
		nome_label.text = fala["nome"]
	else:
		nome_label.visible = false
		
	if fala.has("foto") and fala["foto"] != null:
		retrato.visible = true
		retrato.texture = fala["foto"]
	else:
		retrato.visible = false
		
	texto_label.text = fala["texto"]
	texto_label.visible_ratio = 0.0
	escrevendo = true
	icone_continuar.visible = false
	
	var tempo_leitura = texto_label.text.length() * 0.03
	
	if tween_texto:
		tween_texto.kill()
	
	tween_texto = create_tween()
	tween_texto.tween_property(texto_label, "visible_ratio", 1.0, tempo_leitura)
	tween_texto.finished.connect(_ao_terminar_de_escrever)
	
	# --- INICIA O SOM DE DIGITAÇÃO ---
	# O timer apita a cada 0.05 segundos. Pode alterar esse valor para deixar o som mais rápido ou mais lento!
	if timer_digitacao:
		timer_digitacao.start(0.08)

func _ao_terminar_de_escrever():
	escrevendo = false
	icone_continuar.visible = true
	
	# --- PARA O SOM ---
	if timer_digitacao:
		timer_digitacao.stop()

func _input(event):
	if not painel_fundo.visible:
		return
	
	if event.is_action_pressed("ui_cancel"):
		get_viewport().set_input_as_handled()
		fechar_dialogo()
		return

	if event.is_action_pressed("interagir"):
		get_viewport().set_input_as_handled()
		
		if escrevendo:
			if tween_texto:
				tween_texto.kill()
			texto_label.visible_ratio = 1.0
			_ao_terminar_de_escrever()
		else:
			linha_atual += 1
			if linha_atual < conversa_atual.size(): 
				mostrar_linha_atual()
			else:
				fechar_dialogo()

func fechar_dialogo():
	if tween_texto:
		tween_texto.kill()
	
	# --- GARANTE QUE O SOM NÃO FIQUE TOCANDO SE FECHAR DO NADA ---
	if timer_digitacao:
		timer_digitacao.stop()
	
	painel_fundo.visible = false
	get_tree().paused = false
	
	dialogo_terminou.emit()

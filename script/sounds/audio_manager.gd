extends Node

@onready var musica_player = $MusicaPlayer
@onready var ambiente_player = $AmbientePlayer

var fade_tween: Tween
var fade_ambiente_tween: Tween

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS

# --- MÚSICA ---
func tocar_musica(nova_musica: AudioStream, tempo_fade: float = 2.0, canal: String = "Musica"):
	if musica_player.stream == nova_musica and musica_player.playing: return
	musica_player.bus = canal
	if fade_tween and fade_tween.is_valid(): fade_tween.kill()
	fade_tween = create_tween()
	
	if musica_player.playing:
		fade_tween.tween_property(musica_player, "volume_db", -80.0, tempo_fade)
		fade_tween.tween_callback(trocar_faixa.bind(nova_musica, tempo_fade, canal))
	else:
		trocar_faixa(nova_musica, tempo_fade, canal)

func trocar_faixa(nova_musica: AudioStream, tempo_fade: float, canal: String):
	musica_player.stream = nova_musica
	musica_player.bus = canal
	if nova_musica != null:
		musica_player.volume_db = -80.0 
		musica_player.play()
		fade_tween = create_tween()
		fade_tween.tween_property(musica_player, "volume_db", 0.0, tempo_fade)
	else:
		musica_player.stop()

func parar_musica(tempo_fade: float = 2.0):
	if fade_tween and fade_tween.is_valid(): fade_tween.kill()
	fade_tween = create_tween()
	fade_tween.tween_property(musica_player, "volume_db", -80.0, tempo_fade)
	fade_tween.tween_callback(musica_player.stop)

# --- AMBIENTE (FLORESTA) ---
func tocar_ambiente(novo_ambiente: AudioStream, tempo_fade: float = 2.0, canal: String = "SFX"):
	if ambiente_player.stream == novo_ambiente and ambiente_player.playing: return
	ambiente_player.bus = canal
	if fade_ambiente_tween and fade_ambiente_tween.is_valid(): fade_ambiente_tween.kill()
	fade_ambiente_tween = create_tween()
	
	if ambiente_player.playing:
		fade_ambiente_tween.tween_property(ambiente_player, "volume_db", -80.0, tempo_fade)
		fade_ambiente_tween.tween_callback(trocar_ambiente.bind(novo_ambiente, tempo_fade, canal))
	else:
		trocar_ambiente(novo_ambiente, tempo_fade, canal)

func trocar_ambiente(novo_ambiente: AudioStream, tempo_fade: float, canal: String):
	ambiente_player.stream = novo_ambiente
	ambiente_player.bus = canal
	if novo_ambiente != null:
		ambiente_player.volume_db = -80.0 
		ambiente_player.play()
		fade_ambiente_tween = create_tween()
		fade_ambiente_tween.tween_property(ambiente_player, "volume_db", 0.0, tempo_fade)
	else:
		ambiente_player.stop()

func parar_ambiente(tempo_fade: float = 2.0):
	if fade_ambiente_tween and fade_ambiente_tween.is_valid(): fade_ambiente_tween.kill()
	fade_ambiente_tween = create_tween()
	fade_ambiente_tween.tween_property(ambiente_player, "volume_db", -80.0, tempo_fade)
	fade_ambiente_tween.tween_callback(ambiente_player.stop)

# --- EFEITOS RÁPIDOS ---
func tocar_som(som: AudioStream, canal: String = "SFX"):
	if som == null: return
	var player = AudioStreamPlayer.new()
	add_child(player)
	player.stream = som
	player.bus = canal 
	player.play()
	player.finished.connect(player.queue_free)

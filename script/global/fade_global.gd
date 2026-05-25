extends CanvasLayer

@onready var tela_preta = $TelaPreta

func fade_out(tempo: float = 1.0):
	tela_preta.modulate.a = 0.0 
	
	var tween = create_tween()
	tween.tween_property(tela_preta, "modulate:a", 1.0, tempo)
	await tween.finished


func fade_in(tempo: float = 1.0):
	tela_preta.modulate.a = 1.0 
	
	var tween = create_tween()
	tween.tween_property(tela_preta, "modulate:a", 0.0, tempo)
	
	await tween.finished


func piscar(tempo_total: float = 0.2):
	tela_preta.modulate.a = 0.8 
	await get_tree().create_timer(tempo_total).timeout
	tela_preta.modulate.a = 0.0 

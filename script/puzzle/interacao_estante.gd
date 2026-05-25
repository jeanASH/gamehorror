extends Area2D

var player_perto: bool = false
var player_node = null

func _ready():
	if SaveManager.dados_atuais != null and SaveManager.dados_atuais.puzzle_estante_resolvido == true:
		queue_free()

func _unhandled_input(event):
	if player_perto and event.is_action_pressed("interagir"):
		if SaveManager.dados_atuais.puzzle_estante_resolvido == false:
			abrir_puzzle_da_sala()
		else:
			if player_node: player_node.mostrar_aviso(false)
			queue_free()

func abrir_puzzle_da_sala():
	if player_node and player_node.has_method("mostrar_aviso"):
		player_node.mostrar_aviso(false)
		
	var puzzle = get_tree().current_scene.find_child("PuzzleEstanteUI", true, false)
	if puzzle:
		puzzle.abrir_puzzle()


func _on_body_entered(body):
	if body.name == "Player":
		if SaveManager.dados_atuais.puzzle_estante_resolvido == false:
			player_perto = true
			player_node = body
			if body.has_method("mostrar_aviso"):
				body.mostrar_aviso(true)

func _on_body_exited(body):
	if body.name == "Player":
		player_perto = false
		if body.has_method("mostrar_aviso"):
			body.mostrar_aviso(false)
		player_node = null

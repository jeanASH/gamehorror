extends Area2D

@export_category("Configuração da Missão")
@export var id_nova_missao: String = "procurar_chaves"

func _ready():
	body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	if Engine.is_editor_hint(): return
	

	if body.name == "Player":
		MissaoManager.definir_objetivo_por_id("objetos")
		queue_free()

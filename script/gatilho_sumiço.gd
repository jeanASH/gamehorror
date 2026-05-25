extends Area2D


@export var fantasma_node: Sprite2D 

var ja_aconteceu: bool = false

func _on_body_entered(body: Node2D) -> void:
	
	if body.name == "Player" and not ja_aconteceu:
		ja_aconteceu = true
		executar_sumico()

func executar_sumico():
	await FadeGlobal.fade_out(0.3) 
	if fantasma_node:
		fantasma_node.visible = false
	
	await FadeGlobal.fade_in(0.3)
	queue_free()

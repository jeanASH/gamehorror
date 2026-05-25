extends Control

@onready var botao_sair = $Button 

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	# Conecta o botão
	botao_sair.pressed.connect(_ao_apertar_sair)

func _ao_apertar_sair():
	get_tree().change_scene_to_file("res://scenes/ui/menu_principal.tscn")
	

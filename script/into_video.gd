extends Control

@export_file("*.tscn") var cena_da_rua_real: String

func _ready():
	
	$VideoStreamPlayer.finished.connect(_ao_video_terminar)

func _ao_video_terminar():
	if cena_da_rua_real != "":
		get_tree().change_scene_to_file(cena_da_rua_real)

func _input(event):
	if event.is_action_pressed("pular"):
		_ao_video_terminar()

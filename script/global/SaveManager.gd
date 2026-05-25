extends Node


var slot_selecionado: int = 1
var dados_atuais: SaveGame 
var alvo_spawn: String = ""


func carregar_save(slot: int) -> SaveGame:
	var caminho = "user://save_slot_" + str(slot) + ".tres"
	
	if FileAccess.file_exists(caminho):
		var save = ResourceLoader.load(caminho)
		if save is SaveGame:
			return save
	
	return null 

func salvar_jogo():
	if dados_atuais != null:
		var caminho = "user://save_slot_" + str(slot_selecionado) + ".tres"
		var erro = ResourceSaver.save(dados_atuais, caminho)
		
		if erro == OK:
			print("Sucesso: Jogo salvo no Slot ", slot_selecionado)
		else:
			print("Erro ao salvar: ", erro)
	else:
		print("Erro: Não há dados_atuais para salvar!")


func deletar_save(slot: int):
	var caminho = "user://save_slot_" + str(slot) + ".tres"
	if FileAccess.file_exists(caminho):
		OS.move_to_trash(ProjectSettings.globalize_path(caminho))
		print("Slot ", slot, " deletado.")

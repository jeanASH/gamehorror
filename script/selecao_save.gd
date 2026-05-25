extends Control

@export var musica_da_cena: AudioStream
@export var tempo_de_fade: float = 2.0
@onready var slot1_label = $VBoxContainer/Slot1/HBoxContainer/Info/NomeLabel
@onready var slot2_label = $VBoxContainer2/Slot2/HBoxContainer/Info/NomeLabel

func _ready():
	atualizar_slots_interface()
	if musica_da_cena:
		AudioManager.tocar_musica(musica_da_cena, tempo_de_fade, "UI")

func atualizar_slots_interface():
	var save1 = SaveManager.carregar_save(1)
	if save1:
		slot1_label.text = save1.nome_personagem + " - " + save1.progresso
	else:
		slot1_label.text = "Vazio - Novo Jogo"

	var save2 = SaveManager.carregar_save(2)
	if save2:
		slot2_label.text = save2.nome_personagem + " - " + save2.progresso
	else:
		slot2_label.text = "Vazio - Novo Jogo"


func _on_slot_1_pressed():
	clicou_no_slot(1)

func _on_slot_2_pressed():
	clicou_no_slot(2)

func clicou_no_slot(num):
	
	SaveManager.slot_selecionado = num
	
	var save_existente = SaveManager.carregar_save(num)
	
	if save_existente:
		
		SaveManager.dados_atuais = save_existente
		get_tree().change_scene_to_file(save_existente.cena_atual)
	else:
		get_tree().change_scene_to_file("res://scenes/ui/selecao_personagem.tscn")
		
func _on_botao_deletar_1_pressed():
	SaveManager.deletar_save(1)
	atualizar_slots_interface() 

func _on_botao_deletar_2_pressed():
	SaveManager.deletar_save(2)
	atualizar_slots_interface()
	
func _on_voltar_pressed():
	get_tree().change_scene_to_file("res://scenes/ui/menu_principal.tscn")

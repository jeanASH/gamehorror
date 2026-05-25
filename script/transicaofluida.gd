extends Area2D

@export_file("*.tscn") var cena_destino: String

func _on_body_entered(body):
	if body.name == "Player":

		if SaveManager.dados_atuais != null and SaveManager.dados_atuais.ja_ligou_pra_mae == false:
			var nome = SaveManager.dados_atuais.nome_personagem
			var foto = SaveManager.dados_atuais.foto_personagem

			CaixaDialogoGlobal.iniciar_dialogo(["Não posso ir embora agora, preciso ligar para minha mãe primeiro!"], nome, foto)
			return 
			
		fazer_transicao_automatica()

func fazer_transicao_automatica():
	$CollisionShape2D.set_deferred("disabled", true)
	
	if cena_destino != "":
		await FadeGlobal.fade_out(0.8)
		
		SaveManager.dados_atuais.cena_atual = cena_destino
		SaveManager.salvar_jogo()
		get_tree().change_scene_to_file(cena_destino)
		FadeGlobal.fade_in(0.8)

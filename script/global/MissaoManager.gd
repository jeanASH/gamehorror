extends Node

signal missao_atualizada(texto)

var banco_de_missoes = {
	"estacionamento": "Objetivo:\nAbra a mochila (TAB) e ligue para sua mãe",
	"lanchonete_explorar": "Objetivo:\nVá até a lanchonete esperar seus pais",
	"biblioteca_chave": "Objetivo:\nUse a chave para abrir a porta secreta",
	"investigar_biblioteca": "Objetivo:\nInvestigue a biblioteca mencionada pela faxineira",
	"procurar": "Objetivo:\nAche onde essa chave pode ser usada",
	"objetos": "Objetivo:\nEncontre os 4 elementos que encaixam nos pedestais"
}

var objetivo_atual: String = ""

func definir_objetivo_por_id(id_missao: String):
	if banco_de_missoes.has(id_missao):
		objetivo_atual = banco_de_missoes[id_missao]
		
		if SaveManager.dados_atuais != null:
			SaveManager.dados_atuais.id_missao_atual = id_missao
		
		missao_atualizada.emit(objetivo_atual)
	else:
		print("Erro: ID de missão não encontrado.")

# ESTA FUNÇÃO RESOLVE O SEU PROBLEMA:
func carregar_missao_do_save_atual():
	if SaveManager.dados_atuais != null:
		var id_salvo = SaveManager.dados_atuais.id_missao_atual
		
		if id_salvo != "" and banco_de_missoes.has(id_salvo):
			objetivo_atual = banco_de_missoes[id_salvo]
			missao_atualizada.emit(objetivo_atual)
		else:
			objetivo_atual = ""
			missao_atualizada.emit("")

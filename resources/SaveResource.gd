extends Resource
class_name SaveGame 

@export var puzzle_estante_resolvido: bool = false
@export var encontrou_faxineira: bool = false
@export var lanterna_ligada: bool = true
@export var ja_ligou_pra_mae: bool = false
@export var terceira_vez: bool = false
@export var nome_personagem: String = "Vazio"
@export var cena_atual: String = "res://scenes/levels/entrada_faculdade.tscn"
@export var foto_personagem: Texture2D 
@export var progresso: String = "0%"
@export var data_save: String = ""
@export var genero: String = ""
@export var id_missao_atual: String = ""

#==========================#
	  #inventario
#==========================#
@export var itens_no_bolso: Array[String] = ["Celular"]
@export var itens_pegos_no_mapa: Array[String] = []
@export var pilares_resolvidos: Array[String] = []

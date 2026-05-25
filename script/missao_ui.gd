extends CanvasLayer

@onready var label_missao = $Label 

func _ready():
	MissaoManager.missao_atualizada.connect(_on_missao_atualizada)
	_on_missao_atualizada(MissaoManager.objetivo_atual)

func _on_missao_atualizada(texto):
	if texto == "":
		visible = false
	else:
		visible = true
		label_missao.text = texto

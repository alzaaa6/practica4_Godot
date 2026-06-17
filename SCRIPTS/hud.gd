extends CanvasLayer

@onready var barra_vida: ProgressBar = $Control/MarginContainer/VBoxContainer/BarraVida
@onready var label_oleades: Label = $Control/MarginContainer/VBoxContainer/LabelOleades

func _ready() -> void:
	print("BarraVida: ", barra_vida)
	print("LabelOleades: ", label_oleades)
	barra_vida.max_value = GameManager.vida_max
	barra_vida.value = GameManager.vida_actual
	label_oleades.text = "Oleada: %d/%d" % [GameManager.enemics_eliminats, GameManager.enemics_per_oleada]

func _process(delta: float) -> void:
	barra_vida.value = GameManager.vida_actual
	label_oleades.text = "Oleada: %d/%d" % [GameManager.enemics_eliminats, GameManager.enemics_per_oleada]

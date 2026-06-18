extends CanvasLayer

@onready var barra_vida: TextureProgressBar = $Control/MarginContainer/VBoxContainer/ControlBarraVida/BarraVida
@onready var label_vida: Label = $Control/MarginContainer/VBoxContainer/ControlBarraVida/LabelPorcentatgeVida
@onready var label_oleades: Label = $Control/MarginContainer/VBoxContainer/VBoxContainer/LabelOleades
@onready var label_enemics: Label = $Control/MarginContainer/VBoxContainer/VBoxContainer/LabelEnemics

func _ready() -> void:
	barra_vida.max_value = GameManager.vida_max
	barra_vida.value = GameManager.vida_actual
	label_oleades.text = "Oleada: %d" % GameManager.oleada_actual
	label_enemics.text = "Enemics: %d/%d" % [GameManager.enemics_eliminats, GameManager.enemics_per_oleada]

func _process(delta: float) -> void:
	barra_vida.value = GameManager.vida_actual
	label_vida.text = "%d%%" % [int(GameManager.vida_actual)]
	label_oleades.text = "Oleada: %d" % GameManager.oleada_actual
	label_enemics.text = "Enemics: %d/%d" % [GameManager.enemics_eliminats, GameManager.enemics_per_oleada]

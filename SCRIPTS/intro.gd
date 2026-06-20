extends CanvasLayer

@onready var fons: ColorRect = $Fons
@onready var caixa: PanelContainer = $CaixaText
@onready var label_nom: Label = $CaixaText/MarginContainer/VBoxContainer/LabelNom
@onready var label_text: Label = $CaixaText/MarginContainer/VBoxContainer/LabelText
@onready var label_continuar: Label = $LabelContinuar
@onready var sfx_escriure: AudioStreamPlayer = $SFXEscriure

signal intro_acabada

const TEXTOS := [
	{
		"nom": "Narrador",
		"text": "Les terres de Valdrim eren un lloc de pau... fins que les criatures de les tenebres van despertar dels seus somnis eterns."
	},
	{
		"nom": "Narrador",
		"text": "Legions de monstres han envaït els dungeons sagrats, amenaçant tot allò que els habitants d'aquest món estimen."
	},
	{
		"nom": "Heroi",
		"text": "Només un guerrer valent pot aturar aquesta invasió. El moment ha arribat. Prepara't per lluitar!"
	},
]

var index_actual := 0
var escrivint := false
var text_complet := false

func _ready() -> void:
	caixa.visible = false
	label_continuar.visible = false
	await get_tree().create_timer(0.5).timeout
	_mostrar_text(0)

func _mostrar_text(index: int) -> void:
	index_actual = index
	caixa.visible = true
	label_continuar.visible = false
	label_nom.text = TEXTOS[index]["nom"]
	label_text.text = ""
	escrivint = true
	text_complet = false
	sfx_escriure.play()  # comença el bucle
	
	var text_final: String = TEXTOS[index]["text"]
	for c in text_final:
		if not escrivint:
			break
		label_text.text += c
		await get_tree().create_timer(0.03).timeout
	
	if escrivint:
		escrivint = false
		sfx_escriure.stop()
		label_text.text = TEXTOS[index_actual]["text"]
		text_complet = true
		label_continuar.visible = true

func _input(event: InputEvent) -> void:
	if not visible:
		return
	if event.is_action_pressed("ui_accept"):
		if escrivint:
			escrivint = false
			label_text.text = TEXTOS[index_actual]["text"]
			text_complet = true
			label_continuar.visible = true
		elif text_complet:
			index_actual += 1
			if index_actual >= TEXTOS.size():
				_acabar_intro()
			else:
				_mostrar_text(index_actual)

func _acabar_intro() -> void:
	caixa.visible = false
	label_continuar.visible = false
	var tween := create_tween()
	tween.tween_property(fons, "color", Color(0, 0, 0, 0), 1.5)
	await tween.finished
	intro_acabada.emit()
	queue_free()

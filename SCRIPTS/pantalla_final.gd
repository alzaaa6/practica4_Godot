extends Control

@onready var label_resultat: Label = $VBoxContainer/HBoxContainer/LabelResultat
@onready var label_jugador: Label = $VBoxContainer/LabelUsuariIPersonatge
@onready var label_puntuacio: Label = $VBoxContainer/LabelPuntuacio
@onready var label_millor: Label = $VBoxContainer/LabelMillorPuntuacio

func _ready() -> void:
	GameManager.actualitzar_millor_puntuacio()
	
	label_resultat.text = GameManager.resultat
	label_jugador.text = "%s — %s" % [
		GameManager.nom_jugador,
		GameManager.noms_personatges[GameManager.personatge_seleccionat]
	]
	label_puntuacio.text = "Puntuació: %d" % GameManager.puntuacio
	label_millor.text = "Millor puntuació: %d" % GameManager.millor_puntuacio

func _on_btn_tornar_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://SCENES/PantallaInici.tscn")


func _on_btn_tornar_a_jugar_pressed() -> void:
	GameManager.vida_actual = GameManager.vida_max
	GameManager.oleada_actual = 1
	GameManager.enemics_eliminats = 0
	GameManager.puntuacio = 0
	GameManager.fase_boost = false
	get_tree().change_scene_to_file("res://SCENES/Joc.tscn")

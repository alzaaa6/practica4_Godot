extends Control

@onready var label_resultat: Label = $VBoxContainer/HBoxContainer/LabelResultat
@onready var label_jugador: Label = $VBoxContainer/LabelUsuariIPersonatge
@onready var label_puntuacio: Label = $VBoxContainer/LabelPuntuacio
@onready var label_millor: Label = $VBoxContainer/LabelMillorPuntuacio
@onready var ranking_container: VBoxContainer = $VBoxContainer/RankingContainer

func _ready() -> void:
	label_resultat.text = GameManager.resultat
	label_jugador.text = "%s — %s" % [
		GameManager.nom_jugador,
		GameManager.noms_personatges[GameManager.personatge_seleccionat]
	]
	label_puntuacio.text = "Puntuació: %d" % GameManager.puntuacio
	_mostrar_ranking()
	
func _mostrar_ranking() -> void:
	# Neteja el container
	for child in ranking_container.get_children():
		child.queue_free()
	
	# Capçalera
	var header := Label.new()
	header.text = "— RANKING —"
	header.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	header.add_theme_color_override("font_color", Color("#7a6040"))
	header.add_theme_font_size_override("font_size", 11)
	ranking_container.add_child(header)
	
	# Files del ranking
	for i in GameManager.ranking.size():
		var entry: Dictionary = GameManager.ranking[i]
		var row := Label.new()
		var prefix := "◆" if entry["nom"] == GameManager.nom_jugador and entry["puntuacio"] == GameManager.puntuacio else " "
		row.text = "%s %d. %s (%s) — %d pts" % [
			prefix,
			i + 1,
			entry["nom"],
			entry["personatge"],
			entry["puntuacio"]
		]
		row.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		if prefix == "◆":
			row.add_theme_color_override("font_color", Color("#e8b84b"))
		else:
			row.add_theme_color_override("font_color", Color("#b89060"))
		row.add_theme_font_size_override("font_size", 13)
		ranking_container.add_child(row)

func _on_btn_tornar_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://SCENES/PantallaInici.tscn")


func _on_btn_tornar_a_jugar_pressed() -> void:
	GameManager.vida_actual = GameManager.vida_max
	GameManager.oleada_actual = 1
	GameManager.enemics_eliminats = 0
	GameManager.puntuacio = 0
	GameManager.fase_boost = false
	get_tree().change_scene_to_file("res://SCENES/Joc.tscn")
	
	

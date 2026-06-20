extends Node2D

@onready var options_overlay = $UILayer/OptionsOverlay
@onready var intro: CanvasLayer = $Intro


const BoostScene = preload("res://SCENES/Boost.tscn")

const POSICIONS := [
	Vector2(1129.0, 233.0),
	Vector2(1212.0, 710.0),
	Vector2(524.0, 518.0),
]

func _ready() -> void:
	intro.intro_acabada.connect(_on_intro_acabada)

func _process(delta: float) -> void:
	if GameManager.fase_boost and get_tree().get_nodes_in_group("boost").size() == 0:
		_spawnar_boosts()
	if GameManager.partida_acabada:
		GameManager.partida_acabada = false
		GameManager.actualitzar_ranking()
		get_tree().change_scene_to_file("res://SCENES/PantallaFinal.tscn")

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		_toggle_pausa()
	if event is InputEventMouseButton and event.pressed:
		print("Posició: ", get_global_mouse_position())
	if event is InputEventKey and event.pressed:
		match event.physical_keycode:
			KEY_F1:
				GameManager.rebre_damage(10)
			KEY_F2:
				GameManager.rebre_damage(50)
			KEY_F3:
				GameManager.eliminar_enemic()
			KEY_F5:
				GameManager.aplicar_boost("atac")
				for boost in get_tree().get_nodes_in_group("boost"):
					boost.queue_free()
			KEY_F6:
				GameManager.aplicar_boost("defensa")
				for boost in get_tree().get_nodes_in_group("boost"):
					boost.queue_free()
			KEY_F7:
				GameManager.aplicar_boost("vida")
				for boost in get_tree().get_nodes_in_group("boost"):
					boost.queue_free()

func _toggle_pausa() -> void:
	var pausat := !get_tree().paused
	get_tree().paused = pausat
	options_overlay.visible = pausat
	GameManager.in_game = pausat
	
func _on_intro_acabada() -> void:
	$MusicPlayer.play()

func _spawnar_boosts() -> void:
	for boost in get_tree().get_nodes_in_group("boost"):
		boost.queue_free()
	
	var tipus_boosts := ["vida", "atac", "defensa"]
	tipus_boosts.shuffle()  # ordre aleatori cada oleada
	
	var posicions := POSICIONS.duplicate()
	posicions.shuffle()  # posicions aleatories cada oleada
	
	for i in 3:
		var boost = BoostScene.instantiate()
		add_child(boost)
		boost.add_to_group("boost")
		boost.global_position = posicions[i]
		boost.init(tipus_boosts[i])

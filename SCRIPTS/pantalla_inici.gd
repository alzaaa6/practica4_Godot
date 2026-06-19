extends Control

@onready var sfx_player: AudioStreamPlayer2D = $SFXPlayer
@onready var fade: ColorRect = $Fade
@onready var anim: AnimationPlayer = $Fade/AnimationPlayer
@onready var sfx_jugar: AudioStreamPlayer2D = $SFXPlay
@onready var btn_esquerra: Button = $HBoxContainer/BtnEsquerra
@onready var btn_dreta: Button = $HBoxContainer/BtnDreta
@onready var personatge_img: TextureRect = $HBoxContainer/TextureRect
@onready var label_nom: Label = $LabelNom

var noms := ["Guerrer", "Mag", "Archer"]


var personatge_actual := 0
var personatges := [
	preload("res://ASSETS/personatge1.png"),
	preload("res://ASSETS/personatge2.png"),
	preload("res://ASSETS/personatge3.png"),
]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	actualitzar_personatge()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func actualitzar_personatge() -> void:
	personatge_img.texture = personatges[personatge_actual]
	label_nom.text = noms[personatge_actual]

func _on_btn_options_pressed() -> void:
	sfx_player.play()
	await sfx_player.finished
	get_tree().change_scene_to_file("res://SCENES/Options.tscn")


func _on_btn_play_pressed() -> void:
	sfx_jugar.play()
	anim.play("fade_to_black")
	await anim.animation_finished
	get_tree().change_scene_to_file("res://SCENES/Joc.tscn")


func _on_btn_sortir_pressed() -> void:
	sfx_player.play()
	await sfx_player.finished
	get_tree().quit();


func _on_btn_esquerra_pressed() -> void:
	personatge_actual = (personatge_actual - 1 + personatges.size()) % personatges.size()
	actualitzar_personatge()

func _on_btn_dreta_pressed() -> void:
	personatge_actual = (personatge_actual + 1) % personatges.size()
	actualitzar_personatge()

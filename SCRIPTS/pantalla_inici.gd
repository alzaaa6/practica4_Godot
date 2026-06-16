extends Control

@onready var sfx_player: AudioStreamPlayer2D = $SFXPlayer



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_btn_options_pressed() -> void:
	sfx_player.play()
	await sfx_player.finished
	get_tree().change_scene_to_file("res://SCENES/Options.tscn")


func _on_btn_play_pressed() -> void:
	sfx_player.play()
	await sfx_player.finished
	get_tree().change_scene_to_file("res://SCENES/Joc.tscn")


func _on_btn_sortir_pressed() -> void:
	sfx_player.play()
	await sfx_player.finished
	get_tree().quit();

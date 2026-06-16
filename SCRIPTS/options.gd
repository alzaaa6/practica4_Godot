extends Control

@onready var master_slider: HSlider = $"PanelContainer/VBoxContainer/TabContainer/♪ Àudio/MasterVolume/HSliderMaster"
@onready var music_slider: HSlider = $"PanelContainer/VBoxContainer/TabContainer/♪ Àudio/MusicVolume/HSliderMusic"
@onready var sfx_slider: HSlider = $"PanelContainer/VBoxContainer/TabContainer/♪ Àudio/SFXVolume/HSliderSFX"
@onready var master_label: Label = $"PanelContainer/VBoxContainer/TabContainer/♪ Àudio/MasterVolume/LabelMaster"
@onready var music_label: Label = $"PanelContainer/VBoxContainer/TabContainer/♪ Àudio/MusicVolume/LabelMusic"
@onready var sfx_label: Label = $"PanelContainer/VBoxContainer/TabContainer/♪ Àudio/SFXVolume/LabelSFX"
@onready var sfx_player: AudioStreamPlayer2D = $SFXPlayer

func _ready() -> void:
	# Carrega els valors guardats
	master_slider.value = GameManager.settings["master_volume"]
	music_slider.value  = GameManager.settings["music_volume"]
	sfx_slider.value    = GameManager.settings["sfx_volume"]

func _on_btn_tornar_menu_pressed() -> void:
	sfx_player.play()
	await sfx_player.finished
	get_tree().change_scene_to_file("res://SCENES/PantallaInici.tscn")


func _on_btn_guardar_canvis_pressed() -> void:
	sfx_player.play()
	GameManager.save_settings()


func _on_h_slider_master_value_changed(value: float) -> void:
	GameManager.settings["master_volume"] = value
	AudioServer.set_bus_volume_db(
		AudioServer.get_bus_index("Master"),
		linear_to_db(value / 100.0)
	)
	master_label.text = str(int(value))



func _on_h_slider_music_value_changed(value: float) -> void:
	GameManager.settings["music_volume"] = value
	AudioServer.set_bus_volume_db(
		AudioServer.get_bus_index("Music"),
		linear_to_db(value / 100.0)
	)
	music_label.text = str(int(value))


func _on_h_slider_sfx_value_changed(value: float) -> void:
	GameManager.settings["sfx_volume"] = value
	AudioServer.set_bus_volume_db(
		AudioServer.get_bus_index("SFX"),
		linear_to_db(value / 100.0)
	)
	sfx_label.text = str(int(value))

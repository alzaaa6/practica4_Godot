extends Control

func _ready() -> void:
	# Carrega els valors actuals dels busos d'àudio
	%HSliderMaster.value = db_to_linear(
		AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Master"))
	) * 100.0
	%HSliderMusic.value = db_to_linear(
		AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Music"))
	) * 100.0
	%HSliderSFX.value = db_to_linear(
		AudioServer.get_bus_volume_db(AudioServer.get_bus_index("SFX"))
	) * 100.0

func _on_master_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(
		AudioServer.get_bus_index("Master"),
		linear_to_db(value / 100.0)
	)

func _on_music_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(
		AudioServer.get_bus_index("Music"),
		linear_to_db(value / 100.0)
	)

func _on_sfx_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(
		AudioServer.get_bus_index("SFX"),
		linear_to_db(value / 100.0)
	)

func _process(delta: float) -> void:
	pass

func _on_btn_tornar_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://SCENES/PantallaInici.tscn")

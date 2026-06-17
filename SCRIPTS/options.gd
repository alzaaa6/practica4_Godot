extends Control

@onready var master_slider: HSlider = $"PanelContainer/VBoxContainer/TabContainer/♪ Àudio/MasterVolume/HSliderMaster"
@onready var music_slider: HSlider = $"PanelContainer/VBoxContainer/TabContainer/♪ Àudio/MusicVolume/HSliderMusic"
@onready var sfx_slider: HSlider = $"PanelContainer/VBoxContainer/TabContainer/♪ Àudio/SFXVolume/HSliderSFX"
@onready var master_label: Label = $"PanelContainer/VBoxContainer/TabContainer/♪ Àudio/MasterVolume/LabelMaster"
@onready var music_label: Label = $"PanelContainer/VBoxContainer/TabContainer/♪ Àudio/MusicVolume/LabelMusic"
@onready var sfx_label: Label = $"PanelContainer/VBoxContainer/TabContainer/♪ Àudio/SFXVolume/LabelSFX"
@onready var sfx_player: AudioStreamPlayer2D = $SFXPlayer
@onready var mode_pantalla: OptionButton = $"PanelContainer/VBoxContainer/TabContainer/◈ Gràfics/ModePantalla/OptionButton"
@onready var btn_amunt: Button = $"PanelContainer/VBoxContainer/TabContainer/⌨ Controls/VBoxContainer/GridContainer/HBoxContainer/Btn_Amunt"
@onready var btn_avall: Button = $"PanelContainer/VBoxContainer/TabContainer/⌨ Controls/VBoxContainer/GridContainer/HBoxContainer2/Btn_Avall"
@onready var btn_esquerra: Button = $"PanelContainer/VBoxContainer/TabContainer/⌨ Controls/VBoxContainer/GridContainer/HBoxContainer3/Btn_Esquerra"
@onready var btn_dreta: Button = $"PanelContainer/VBoxContainer/TabContainer/⌨ Controls/VBoxContainer/GridContainer/HBoxContainer4/Btn_Dreta"
@onready var btn_atac: Button = $"PanelContainer/VBoxContainer/TabContainer/⌨ Controls/VBoxContainer2/GridContainer/HBoxContainer/Btn_Atac"
@onready var btn_inventari: Button = $"PanelContainer/VBoxContainer/TabContainer/⌨ Controls/VBoxContainer3/GridContainer/HBoxContainer/Btn_Inventari"
@onready var btn_pausa: Button = $"PanelContainer/VBoxContainer/TabContainer/⌨ Controls/VBoxContainer3/GridContainer/HBoxContainer2/Btn_Pausa"


var _accio_remapejant := ""

func _ready() -> void:
	set_anchors_preset(Control.PRESET_FULL_RECT)
	master_slider.value = GameManager.settings["master_volume"]
	music_slider.value  = GameManager.settings["music_volume"]
	sfx_slider.value    = GameManager.settings["sfx_volume"]
	mode_pantalla.selected = GameManager.settings["window_mode"]
	_actualitza_labels_controls()

func _on_btn_tornar_menu_pressed() -> void:
	sfx_player.play()
	if GameManager.in_game:
		get_tree().paused = false
		get_tree().change_scene_to_file("res://SCENES/PantallaInici.tscn")
	else:
		await sfx_player.finished
		get_tree().change_scene_to_file("res://SCENES/PantallaInici.tscn")

func _on_btn_guardar_canvis_pressed() -> void:
	sfx_player.play()
	GameManager.save_settings()
	if GameManager.in_game:
		get_tree().paused = false
		visible = false
	else:
		await sfx_player.finished
		get_tree().change_scene_to_file("res://SCENES/PantallaInici.tscn")

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
	
func _on_option_button_item_selected(index: int) -> void:
	GameManager.settings["window_mode"] = index
	GameManager.apply_window_mode()

func _actualitza_labels_controls() -> void:
	btn_amunt.text     = _get_key_name("move_up")
	btn_avall.text     = _get_key_name("move_down")
	btn_esquerra.text  = _get_key_name("move_left")
	btn_dreta.text     = _get_key_name("move_right")
	btn_atac.text      = _get_key_name("attack")
	btn_inventari.text = _get_key_name("inventory")
	btn_pausa.text     = _get_key_name("pause")
	
func _get_key_name(accio: String) -> String:
	var events := InputMap.action_get_events(accio)
	if events.size() > 0 and events[0] is InputEventKey:
		return OS.get_keycode_string(events[0].physical_keycode)
	return "---"

func _input(event: InputEvent) -> void:
	if _accio_remapejant == "":
		return
	if event is InputEventKey and event.pressed and not event.echo:
		InputMap.action_erase_events(_accio_remapejant)
		var ev := InputEventKey.new()
		ev.physical_keycode = event.physical_keycode
		InputMap.action_add_event(_accio_remapejant, ev)
		_accio_remapejant = ""
		_actualitza_labels_controls()
		get_viewport().set_input_as_handled()

func _on_btn_amunt_pressed() -> void:
	_accio_remapejant = "move_up"
	btn_amunt.text = "[ ... ]"

func _on_btn_avall_pressed() -> void:
	_accio_remapejant = "move_down"
	btn_avall.text = "[ ... ]"

func _on_btn_esquerra_pressed() -> void:
	_accio_remapejant = "move_left"
	btn_esquerra.text = "[ ... ]"

func _on_btn_dreta_pressed() -> void:
	_accio_remapejant = "move_right"
	btn_dreta.text = "[ ... ]"

func _on_btn_atac_pressed() -> void:
	_accio_remapejant = "attack"
	btn_atac.text = "[ ... ]"

func _on_btn_inventari_pressed() -> void:
	_accio_remapejant = "inventory"
	btn_inventari.text = "[ ... ]"

func _on_btn_pausa_pressed() -> void:
	_accio_remapejant = "pause"
	btn_pausa.text = "[ ... ]"

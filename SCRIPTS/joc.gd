extends Node2D

@onready var options_overlay = $UILayer/OptionsOverlay

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		_toggle_pausa()
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
			KEY_F6:
				GameManager.aplicar_boost("defensa")
			KEY_F7:
				GameManager.aplicar_boost("vida")

func _toggle_pausa() -> void:
	var pausat := !get_tree().paused
	get_tree().paused = pausat
	options_overlay.visible = pausat
	GameManager.in_game = pausat

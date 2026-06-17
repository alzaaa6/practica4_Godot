extends Node2D

@onready var options_overlay = $UILayer/OptionsOverlay

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		_toggle_pausa()
	# Debug
	if event is InputEventKey and event.pressed:
		match event.physical_keycode:
			KEY_F1:
				print("F1 premut!")
				GameManager.rebre_damage(10)
			KEY_F2:
				print("F2 premut!")
				GameManager.rebre_damage(50)
			KEY_F3:
				print("F3 premut!")
				GameManager.eliminar_enemic()

func _toggle_pausa() -> void:
	var pausat := !get_tree().paused
	get_tree().paused = pausat
	options_overlay.visible = pausat
	GameManager.in_game = pausat

class_name Arena extends Node2D

@export var cuc_scene: PackedScene

func _on_spawneja_cucs_timer_timeout():
	if cuc_scene != null:
		# Instanciem el cuc
		var cuc = cuc_scene.instantiate()
		# L'afegim a l'escena.
		add_child(cuc)

class_name Projectil_Abella extends Area2D

const SPEED = 400.0
var direction = Vector2.ZERO

func _physics_process(delta):
	# Movem el projectil constantment en la direcció establerta
	global_position += direction * SPEED * delta

func _on_body_entered(body):
	if body.is_in_group("player"):
		body.take_damage(10)
		queue_free() # El projectil es destrueix en xocar amb el jugador

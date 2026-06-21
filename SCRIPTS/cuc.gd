class_name Cuc extends Area2D

@onready var alerta = $Alerta
@onready var cos_cuc = $CosCuc
@onready var hitbox_shape = $CollisionShape2D
@onready var fase_timer = $FaseTimer

var fase = 0 # 0 = Fase d'Alerta, 1 = Fase Activa

func _ready():
	# Es posiciona on està el player
	var player = get_tree().get_first_node_in_group("player")
	if player != null:
		global_position = player.global_position
		
	# Assegurem l'estat inicial de la Fase 0
	alerta.show()
	cos_cuc.hide()
	# desactivem la col·lisió del cuc per si de cas
	hitbox_shape.set_deferred("disabled", true) 
	
	# Fase d'alerta de 1.5 segons
	fase_timer.start(1.5)

func canvi_de_fase():
	if fase == 0:
		# El cuc surt de terra
		alerta.hide()
		cos_cuc.show()
		hitbox_shape.set_deferred("disabled", false)
		
		fase = 1
		# Comencem el temporitzador de 2 segons abans de desaparèixer
		fase_timer.start(2.0)
	elif fase == 1:
		# El cuc desapareix
		queue_free()

func _on_fase_timer_timeout():
	canvi_de_fase()

func _on_body_entered(body):
	# Comprovem si qui trepitja al cuc verd és el player
	if body.is_in_group("player"):
		body.take_damage(10)

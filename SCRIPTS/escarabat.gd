extends CharacterBody2D

const SPEED = 100.0
var player = null
var fase = 0 # 0 = Caminant, 1 = Preparant explosió, 2 = Explotant

@onready var color_rect_explosio = $AreaExplosio/ColorRect
@onready var hitbox_explosio = $AreaExplosio/CollisionShape2D
@onready var fase_timer = $FaseTimer
@onready var area_explosio = $AreaExplosio

func _ready():
	player = get_tree().get_first_node_in_group("player")
	# Ens assegurem que l'explosió està apagada en néixer
	color_rect_explosio.hide()
	hitbox_explosio.set_deferred("disabled", true)

func _physics_process(delta):
	# Només es mou si està a la Fase 0
	if player != null and fase == 0:
		var direction = global_position.direction_to(player.global_position)
		velocity = direction * SPEED
		move_and_slide()

func die():
	# Aquesta funció és la que crida l'espasa.
	# En comptes de fer queue_free() directament, iniciem l'explosió.
	iniciar_explosio()

func iniciar_explosio():
	# Només podem iniciar-la si no s'ha iniciat ja abans
	if fase == 0:
		fase = 1
		# S'atura automàticament perquè _physics_process deixa d'aplicar velocitat
		fase_timer.start(1.25)

func detonar():
	fase = 2
	# Mostrem l'àrea i activem la hitbox
	color_rect_explosio.show()
	hitbox_explosio.set_deferred("disabled", false)
	
	# L'explosió dura 0.5 segons
	fase_timer.start(0.5)
	
	# Comprovem si el jugador ja estava dins de l'àrea just en explotar
	check_hits_explosio()

func check_hits_explosio():
	await get_tree().physics_frame
	var bodies = area_explosio.get_overlapping_bodies()
	for body in bodies:
		if body.is_in_group("player"):
			body.take_damage(50)

func _on_hitbox_body_entered(body):
	# Si xoca amb el jugador a la Fase 0, fa mal i comença a explotar
	if fase == 0 and body.is_in_group("player"):
		body.take_damage(10)
		iniciar_explosio()

func _on_fase_timer_timeout():
	if fase == 1:
		# Han passat els 2 segons d'espera, toca explotar
		detonar()
	elif fase == 2:
		# Ha passat el mig segon de l'explosió, eliminem l'enemic
		queue_free()

func _on_area_explosio_body_entered(body):
	# Si el jugador entra a l'àrea MENTRE està l'explosió activa
	if fase == 2 and body.is_in_group("player"):
		body.take_damage(50)

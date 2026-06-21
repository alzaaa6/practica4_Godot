extends CharacterBody2D

const SPEED = 80.0 
const SHOOT_RANGE = 300.0 

@export var laser_scene: PackedScene

@onready var shoot_timer = $ShootTimer
var player = null

func _ready():
	player = get_tree().get_first_node_in_group("player")
	# Ens assegurem per codi que el timer NO es repeteixi automàticament, 
	# ja que alterna entre 1 i 5 segons
	shoot_timer.one_shot = true

func _physics_process(delta):
	if player == null:
		return
		
	var distance_to_player = global_position.distance_to(player.global_position)
	
	if distance_to_player > SHOOT_RANGE:
		# Si està lluny es mou cap al player
		var direction = global_position.direction_to(player.global_position)
		velocity = direction * SPEED
		move_and_slide()
		
		# Si s'allunya el player aturem el player, reiniciem a 1 segon el timer
		if not shoot_timer.is_stopped():
			shoot_timer.stop()
	else:
		# Si està a rang, es para i carrega el làser
		if shoot_timer.is_stopped():
			# Només en entrar el rang carregarà el làser durant 1.5 segons
			shoot_timer.start(1.5)

func shoot():
	if player != null and laser_scene != null:
		var laser = laser_scene.instantiate()
		var distance = global_position.distance_to(player.global_position)
		laser.longitud = distance + 200.0
		
		# Afegim a l'escena principal
		get_parent().add_child(laser)
		
		# Fem que surti de la formiga
		laser.global_position = global_position
		
		# Fem que giri sobre si mateix per apuntar al jugador
		laser.look_at(player.global_position)

func die():
	queue_free()

func _on_hitbox_body_entered(body):
	if body.is_in_group("player"):
		body.take_damage(10)

func _on_shoot_timer_timeout():
	# Dispara al arribar el timer a 0
	shoot()
	
	# Un cop ha disparat el primer cop (d'1 segon), configurem el timer
	# per preparar el següent disparo d'aquí a 5 segons.
	shoot_timer.start(3.0)

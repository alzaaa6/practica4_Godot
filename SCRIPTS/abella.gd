class_name Abella extends CharacterBody2D

const SPEED = 80.0 # L'abella va més lenta que el player
const SHOOT_RANGE = 500.0 # Distància a la qual s'atura per disparar

# Exportem una variable on arrossegarem l'escena del projectil
@export var projectil_scene: PackedScene

@onready var shoot_timer = $ShootTimer
var player = null

func _ready():
	player = get_tree().get_first_node_in_group("player")

func _physics_process(delta):
	if player == null:
		return
		
	# Calculem a quina distància està del jugador
	var distance_to_player = global_position.distance_to(player.global_position)
	
	if distance_to_player > SHOOT_RANGE:
		# Si esta fora de rang, es mou cap al player
		var direction = global_position.direction_to(player.global_position)
		velocity = direction * SPEED
		move_and_slide()
		
		# Si ens estem movent, parem el temporitzador de disparar
		if not shoot_timer.is_stopped():
			shoot_timer.stop()
	else:
		# Si esta a rango es para i dispara
		if shoot_timer.is_stopped():
			# Si esta a rang i el timer no està en marxa, l'iniciem
			shoot_timer.start()

func shoot():
	# Comprovem que tenim el projectil carregat a l'Inspector i el jugador existeix
	if player != null and projectil_scene != null:
		var proj = projectil_scene.instantiate()
		# Afegim el projectil a l'escena
		get_parent().add_child(proj)
		# Posicionem el projectil just on està l'abella
		proj.global_position = global_position
		# Calculem la direcció recta des de l'abella fins a la posició ACTUAL del jugador
		proj.direction = global_position.direction_to(player.global_position)

func die():
	# Cridat per l'espasa del player
	queue_free()

func _on_hitbox_body_entered(body):
	if body.is_in_group("player"):
		body.take_damage(10)

func _on_shoot_timer_timeout():
	shoot()

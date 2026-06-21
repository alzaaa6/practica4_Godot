class_name Aranya extends CharacterBody2D

const SPEED = 100.0 # L'aranya és més lenta que el player
var player = null

func _ready():
	# En iniciar, busca qui és el player dins l'arbre de l'escena
	player = get_tree().get_first_node_in_group("player")

func _physics_process(delta):
	if player != null:
		# Busca l'angle/direcció des de l'aranya cap a la posició del jugador
		var direction = global_position.direction_to(player.global_position)
		
		velocity = direction * SPEED
		move_and_slide()

# Funció que crida l'espasa del player per matar aquest enemic
func die():
	queue_free()

func _on_hitbox_body_entered(body):
	# Si el cos que entra en contacte està al grup "player"
	if body.is_in_group("player"):
		body.take_damage(10) # Restem 10% de vida
		die() # L'enemic desapareix

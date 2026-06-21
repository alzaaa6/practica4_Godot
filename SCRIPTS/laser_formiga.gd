extends Area2D

var longitud = 0.0
var fase = 0 # 0 = Alerta, 1 = Làser instantani, 2 = Rastre

@onready var color_rect = $ColorRect
@onready var hitbox = $CollisionShape2D
@onready var timer = $FaseTimer

func _ready():
	# Alerta
	color_rect.size = Vector2(longitud, 20)
	color_rect.position = Vector2(0, -10)
	color_rect.color = Color(1.0, 0.0, 0.0, 0.5) 
	
	# Configurem la colisió
	var rect_shape = RectangleShape2D.new()
	rect_shape.size = Vector2(longitud, 20)
	hitbox.shape = rect_shape
	hitbox.position = Vector2(longitud / 2.0, 0)
	
	# L'alerta durarà 0.5 segons
	timer.start(0.5)

func canvi_de_fase():
	if fase == 0:
		# Disparo del làser
		fase = 1
		color_rect.color = Color(1.0, 0.6, 0.0, 1.0)
		# Temps del làser actiu 0.5 segons
		timer.start(0.5)
		# Comprovem si el jugador es troba a dins just en aquest instant
		check_hits(30)
		
	elif fase == 1:
		# Rastre del làser
		fase = 2
		color_rect.color = Color(1.0, 0.6, 0.0, 0.4)
		timer.start(5.0)
		
	elif fase == 2:
		# Fi del rastre, el destruïm
		queue_free()

func check_hits(damage):
	# Comprova els cossos superposats manualment al canviar de fase
	var bodies = get_overlapping_bodies()
	for body in bodies:
		if body.is_in_group("player"):
			body.take_damage(damage)

func _on_fase_timer_timeout():
	canvi_de_fase()

func _on_body_entered(body):
	if body.is_in_group("player"):
		# Depenent de la fase fa un dany diferent, a la 0 no fa res
		if fase == 1:
			body.take_damage(30)
		elif fase == 2:
			body.take_damage(10)

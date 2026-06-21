class_name Player extends CharacterBody2D

const SPEED = 250.0
var health = 100

@onready var weapon_pivot = $WeaponPivot
@onready var sword_area = $WeaponPivot/Sword
var is_attacking = false

func _physics_process(delta):
	handle_movement()
	
	# Només podem apuntar l'arma si no estem enmig d'un atac
	if not is_attacking:
		aim_weapon()
		
	if Input.is_action_just_pressed("attack") and not is_attacking:
		swing_sword()
	
	#Si estem atacant comprovem si l'arma toca algo
	if is_attacking:
		check_sword_hits()

func handle_movement():
	# Obtenim un vector direccional basat en WASD o Fletxes
	var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	# Fem servir moviment X Y normal, amb el tileset ja donem profunditat
	velocity = direction * SPEED
	move_and_slide()

func aim_weapon():
	var mouse_pos = get_global_mouse_position()
	# Calculem l'angle exacte del player al mouse
	var angle_to_mouse = global_position.angle_to_point(mouse_pos)
	# Agrupem aquest angle en 8 possibles direccions
	var snapped_angle = snapped(angle_to_mouse, PI / 4.0)
	# Apliquem la rotació al weaponpivot
	weapon_pivot.rotation = snapped_angle

func swing_sword():
	is_attacking = true
	var tween = create_tween()
	var start_rot = weapon_pivot.rotation
	
	# L'arma fa un swing
	weapon_pivot.rotation = start_rot - (PI / 4.0)
	
	# Fem el cop en 0.15 segons
	tween.tween_property(weapon_pivot, "rotation", start_rot + (PI / 4.0), 0.15).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	# Retornem l'arma a la posició original en 0.1 segons
	tween.tween_property(weapon_pivot, "rotation", start_rot, 0.1)
	
	# Esperem que acabi l'animació per poder fer un altre atac
	await tween.finished
	is_attacking = false

func check_sword_hits():
	# Obtenim tots els cossos que estan dins de l'Area2D de l'arma
	var bodies = sword_area.get_overlapping_bodies()
	for body in bodies:
		# Si un dels cossos te l'etiqueta enemy el matem
		if body.is_in_group("enemy"):
			body.die()

func take_damage(amount):
	health -= amount
	print("El jugador ha rebut mal! Vida restant: ", health, "%")
	# Mes endavant connectarem la senyal per baixar la barra del hud
	if health <= 0:
		print("Game Over")
		# queue_free() #De moment no eliminem el player

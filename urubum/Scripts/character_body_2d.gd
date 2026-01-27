extends CharacterBody2D

#variávei gerais
var Health = 10
var maxSpeed : int = 400
var speed : int = 400
var lookDirection : int = 1
var maxJumpHeigh : int = -1000
var gravityForce : int = 2500
var isCrouch : bool
var speedCrouch : int = 200

#ataque
var isAttacking : bool
var hasAttack : bool
var attackDamage : int = 1

#imports
@onready var collisionArea = $attackCollision
@onready var sprite_rend = $playerSprites
@onready var coyote_timer = $CoyoteTimer

func _physics_process(delta: float) -> void:
	update_animation()
	input_and_move()
	coyote_and_move_slide()
	jump()
	flipAttack()
	
	#detectando se player está no chão
	if not is_on_floor():
		velocity.y += gravityForce * delta
	
#setando animações
func update_animation():
	if isAttacking:
		return
		
	elif not is_on_floor():
		if velocity.y >=0:
			sprite_rend.play("jump")
		else:
			sprite_rend.play("fall")
	
	elif isCrouch:
		if velocity.x != 0:
			sprite_rend.play ("crouchWalk")
		else:
			sprite_rend.play("crouch")
			
	elif velocity.x != 0:
		sprite_rend.play("run")
	
	else:
		sprite_rend.play("idle")
		
	#flip sprite
	sprite_rend.scale.x = 4 * lookDirection

# definindo pulo
func jump():
	if Input.is_action_just_pressed("jump") and (is_on_floor() or !coyote_timer.is_stopped()):
		velocity.y = maxJumpHeigh
	if Input.is_action_just_released("jump") and velocity.y <0:
		velocity.y = 0

#inputs gerais e aplicando movimento
func input_and_move():
	
	var direction = inputDirection()
	
	if direction != 0:
		lookDirection = sign(direction)
	
	if direction:
		velocity.x = direction * speed
		if isCrouch == true:
			velocity.x = direction * speedCrouch
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
	
	#input de agachar
	if Input.is_action_pressed("crouch") && is_on_floor():
		isCrouch = true;
		
	if Input.is_action_just_released("crouch"):
		isCrouch = false;
	
	#input de ataque
	if Input.is_action_just_pressed("attack") && not isAttacking:
		sprite_rend.play("attack1")
		isAttacking = true;
	
#coyote time e move and slide
func coyote_and_move_slide():
	var was_on_floor = is_on_floor()
	
	move_and_slide()
	
	if was_on_floor &&  !is_on_floor():
		coyote_timer.start()

#ready para definir que animação de ataque acabou para poder atacar de novo
func _ready():
	sprite_rend.animation_finished.connect(_on_animation_finished)
	
#denifnindo que a animação acabou
func _on_animation_finished():
	print("animação acabou")
	isAttacking = false;
	hasAttack = false;
	
#pegando posição do player para câmera
func getPlayerPos():
	return global_position;
	
#input de direção para servir de guia para tudo que acompanha o player
func inputDirection():
	return(Input.get_axis("ui_left", "ui_right"))
	
#trocar o ataque pro lado que o player olha
func flipAttack():
	if not isAttacking && inputDirection() != 0:
		collisionArea.scale.x = lookDirection

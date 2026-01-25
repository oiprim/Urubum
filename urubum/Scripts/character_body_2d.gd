extends CharacterBody2D

var Health = 10
@export var maxSpeed : int = 400
@export var speed : int = 400
@export var maxJumpHeigh : int = -1000
@export var gravityForce : int = 2500
@export var isCrouch : bool
@export var speedCrouch : int = 200

var isAttacking : bool
var attackDamage : int = 1

@onready var sprite_rend = $playerSprites
@onready var coyote_timer = $CoyoteTimer

func _physics_process(delta: float) -> void:
	#region sprites
	
	if isAttacking:
		sprite_rend.play("attack1")
		
	elif not is_on_floor():
		if velocity.y >=0:
			sprite_rend.play("jump")
		else:
			sprite_rend.plau("fall")
	
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
	if velocity.x > 0:
		sprite_rend.scale.x = 4
	elif velocity.x < 0:
		sprite_rend.scale.x = -4
	
	#endregion
	
	#region Gravidade.
	
	if not is_on_floor():
		if(velocity.y <= 0 ):
			sprite_rend.play("jump");
		elif(velocity.y >= 0):
			sprite_rend.play("fall");
		velocity += Vector2(velocity.x, gravityForce) * delta
	#endregion
	
	#region Pulo
	
	if Input.is_action_just_pressed("jump") and (is_on_floor() or !coyote_timer.is_stopped()):
		velocity.y = maxJumpHeigh
	if Input.is_action_just_released("jump") and velocity.y <0:
		velocity.y = 0
	#endregion
	
	#region Pega input e movimenta
	
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * speed
		if isCrouch == true:
			velocity.x = direction * speedCrouch
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		
	if Input.is_action_pressed("crouch") && is_on_floor():
		isCrouch = true;
		
	if Input.is_action_just_released("crouch"):
		isCrouch = false;
		
	if Input.is_action_just_pressed("attack"):
		isAttacking = true;
		
	#endregion
	
	#region Coyote Time e Move and Slide
	var was_on_floor = is_on_floor()
	
	move_and_slide()
	
	if was_on_floor &&  !is_on_floor():
		coyote_timer.start()
	#endregion
	
func _ready():
	sprite_rend.animation_finished.connect(_on_animation_finished)
	
func _on_animation_finished():
	print("animação acabou")
	isAttacking = false;
	
func getPlayerPos():
	
	return global_position;

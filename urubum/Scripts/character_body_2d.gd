extends CharacterBody2D


@export var speed : int = 400
@export var maxJumpHeigh : int = -1000
@export var gravityForce : int = 2500

@onready var sprite_rend = $playerSprites
@onready var coyote_timer = $CoyoteTimer

func _physics_process(delta: float) -> void:
	if velocity.x != 0:
		sprite_rend.play("run");
		if velocity.x >= 0:
			sprite_rend.scale.x = 4
		else: sprite_rend.scale.x = -4
	else:
		sprite_rend.play("idle");

	# Add the gravity.
	if not is_on_floor():
		if(velocity.y <= 0 ):
			sprite_rend.play("jump");
		elif(velocity.y >= 0):
			sprite_rend.play("fall");
		velocity += Vector2(velocity.x, gravityForce) * delta

	# Pulo
	if Input.is_action_just_pressed("ui_accept") and (is_on_floor() or !coyote_timer.is_stopped()):
		velocity.y = maxJumpHeigh
	if Input.is_action_just_released("ui_accept") and velocity.y <0:
		velocity.y = 0

	# Pega input e movimenta
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
	
	#Coyote Time && Move and Slide
	var was_on_floor = is_on_floor()
	
	move_and_slide()
	
	if was_on_floor &&  !is_on_floor():
		coyote_timer.start()
	
func getPlayerPos():
	return global_position;

extends CharacterBody2D


@export var speed : int = 400
@export var maxJumpHeigh : int = -1000
@export var gravityForce : int = 2500

@onready var spriteRend = $playerSprites
const somzin = "res://hit.mp3"

func _physics_process(delta: float) -> void:
	if velocity.x != 0:
		spriteRend.play("run");
		if velocity.x >= 0:
			spriteRend.scale.x = 4
		else: spriteRend.scale.x = -4
	else:
		spriteRend.play("idle");

	# Add the gravity.
	if not is_on_floor():
		if(velocity.y <= 0 ):
			spriteRend.play("jump");
		elif(velocity.y >= 0):
			spriteRend.play("fall");
		velocity += Vector2(velocity.x, gravityForce) * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = maxJumpHeigh
	if Input.is_action_just_released("ui_accept") and velocity.y <0:
		velocity.y = 0

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)

	move_and_slide()
	
func getPlayerPos():
	return global_position;

extends CharacterBody2D


const SPEED = 400.0
const JUMP_VELOCITY = -600.0

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
		velocity += Vector2(velocity.x, 1000) * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
	
func getPlayerPos():
	return global_position;

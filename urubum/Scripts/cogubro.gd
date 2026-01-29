extends RigidBody2D

#region Definindo Variaveis

#varáveis padrão
var speed := 200
var rushSpeed := 700
var lookDirection
var maxTimeToRush := 90
var timeToRush := maxTimeToRush
var maxTimeRush := 20
var rushTime := maxTimeRush
@export var spriteRend : AnimatedSprite2D

#sistema de combate
var health : int = 3


#detecções
@export var player : CharacterBody2D
@export var wallDetection : RayCast2D
@export var playerDetection : Area2D
@export var attackDetection : Area2D 

enum STATES { IDLE, PATROL, PREPARE, RUSH}
var state: STATES = STATES.PATROL

#endregion

func _ready() -> void:
	attackDetection = get_tree().get_first_node_in_group("attackCollision");
	

func _physics_process(_delta) -> void:
	
	if(attackDetection.get_overlapping_bodies().has(self) && player.isAttacking && not player.hasAttack):
		takeDamage()
		player.hasAttack = true
	
	
	if(playerDetection.get_overlapping_bodies() and state != STATES.PREPARE and state != STATES.RUSH):
		state = STATES.PREPARE
	
	match state:
		
		STATES.IDLE:
			idle();
		STATES.PATROL:
			patrol();
		STATES.PREPARE:
			prepare();
		STATES.RUSH:
			rush();

#@warning_ignore("unused_parameter")
#func flipSprite(body): #Flipar o sprite do inimigo
#	spriteRend.flip_h = !spriteRend.flip_h 


#region Definindo cada estado do inimigo

func idle():
	self.linear_velocity = Vector2(0, self.linear_velocity.y); #Definindo que tenho que ficar parado

func patrol(): #Rondar de um lado para o outro
	spriteRend.play("running")
	
	if spriteRend.flip_h == false:
		lookDirection = 1 
	else: lookDirection = -1  #Definindo o lado da procura
	
	self.linear_velocity = Vector2(speed * lookDirection, self.linear_velocity.y); #Mandando ele andar
	
	if wallDetection.is_colliding():
		spriteRend.flip_h = !spriteRend.flip_h
		wallDetection.target_position.x *= -1
		
		
func prepare():
	
	#if wallDetection.is_colliding(): TENTANDO ARRUMAR O INIMIGO PRA NÃO
	#	return
		
	spriteRend.play("idle");
	lookDirection = sign(player.global_position.x - global_position.x)
	timeToRush -= 1;
	

	if(lookDirection == -1):
		spriteRend.flip_h = true
	else: spriteRend.flip_h = false

	if(timeToRush <= 0):
		timeToRush = maxTimeToRush;
		state = STATES.RUSH;
	
	self.linear_velocity = Vector2(0, self.linear_velocity.y);
	
func rush():
	print(rushTime)
	spriteRend.play("rushing");
	rushTime -= 1;
	
	if(lookDirection == -1):
		spriteRend.flip_h = true
	else: spriteRend.flip_h = false
	
	self.linear_velocity = Vector2(rushSpeed * lookDirection, self.linear_velocity.y);
	
	if wallDetection.is_colliding():
		rushTime = maxTimeRush
		spriteRend.flip_h = !spriteRend.flip_h
		wallDetection.target_position.x *= -1
		state= STATES.PATROL
		return
	
	if(rushTime <= 0):
		rushTime = maxTimeRush;
		state = STATES.PATROL;
		
#endregion

#region combate

func takeDamage():
	health = health - player.attackDamage;
	print (health)
	
	if health <= 0:
		queue_free()


#endregion

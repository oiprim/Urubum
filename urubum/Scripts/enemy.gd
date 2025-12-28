extends RigidBody2D

#region Definindo Variaveis

var baseSpeed := 200
var rushSpeed := 700
var speed := baseSpeed
var lookDirection
var maxTimeToRush := 90
var timeToRush := maxTimeToRush
var maxTimeRush := 20
var rushTime := maxTimeRush

@onready var player := $"../Player"
@onready var wallDetection := $DetectWalls
@onready var playerDetection := $DetectPlayer
@onready var spriteRend := $enemySprites

enum STATES { IDLE, PATROL, PREPARE, RUSH}
var state: STATES = STATES.PATROL

#endregion

func _physics_process(_delta):
	if(playerDetection.get_overlapping_bodies() and state != STATES.PREPARE and state != STATES.RUSH):
		state = STATES.PREPARE
	
	#COMENTEI SEU CÓDIOG AQUI EM CIMA
	#TO TENTANDO FAZER O INIMIGO ALTERNAR ENTRE ATAQUE E PATROL AQUI EMBAIXO
	
	#if (playerDetection.area_entered(player)) and state != STATES.PREPARE and state != STATES.RUSH:
		#state = STATES.PREPARE
	#if (playerDetection.area_exited(player)) and state == STATES.PREPARE:
		#state = STATES.PATROL
	
	match state:
		
		STATES.IDLE:
			idle();
		STATES.PATROL:
			patrol();
		STATES.PREPARE:
			prepare();
		STATES.RUSH:
			rush();


@warning_ignore("unused_parameter")
func virar(body): #Flipar o sprite do inimigo
	spriteRend.flip_h = !spriteRend.flip_h 

#region Definindo cada estado do inimigo

func idle():
	self.linear_velocity = Vector2(0, self.linear_velocity.y); #Definindo que tenho que ficar parado

func patrol(): #Rondar de um lado para o outro
	spriteRend.play("running")
	speed = baseSpeed
	if(spriteRend.flip_h == false): 
		lookDirection = 1 
	else: lookDirection = -1  #Definindo o lado da procura
	
	self.linear_velocity = Vector2(speed * lookDirection, self.linear_velocity.y); #Mandando ele andar
	
	if not wallDetection.body_entered.is_connected(virar):
		wallDetection.body_entered.connect(virar)#Virando quando bate na parede

func prepare():
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
	spriteRend.play("rushing");
	rushTime -= 1;
	
	if(lookDirection == -1):
		spriteRend.flip_h = true
	else: spriteRend.flip_h = false
	
	
	self.linear_velocity = Vector2(rushSpeed * lookDirection, self.linear_velocity.y);
	
	if(rushTime <= 0):
		state = STATES.PREPARE;
		rushTime = maxTimeRush;

#endregion

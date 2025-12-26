extends RigidBody2D

var baseSpeed = 200
var rushSpeed = 800
var speed = baseSpeed
var searchSide
@onready var player := $"../Player"
@onready var wallDetection := $DetectWalls
@onready var playerDetection := $DetectPlayer
@onready var spriteRend := $enemySprites

@onready var spritePerState = [ #Guardando Sprites
preload("res://Sprites/Urubao.png"), #IDLE -> 0
];

func ready():
	pass

enum STATES { IDLE, SEARCH, CHASE}
var state: STATES = STATES.SEARCH

func _physics_process(_delta):
	
	if(playerDetection.has_overlapping_bodies()):
		state = STATES.CHASE


	match state:
		
		STATES.IDLE:
			idle();

		STATES.SEARCH:
			search();

		STATES.CHASE:
			chase();



@warning_ignore("unused_parameter")
func virar(body): #Flipar o sprite do inimigo
	spriteRend.flip_h = !spriteRend.flip_h 

#region StatesFunction #definindo cada função do inimigo

func idle():
	self.linear_velocity = Vector2(0, self.linear_velocity.y); #Definindo que tenho que ficar parado

func search(): #Rondar de um lado para o outro
	spriteRend.play("running")
	speed = baseSpeed
	if(spriteRend.flip_h == false): 
		searchSide = 1 
	else: searchSide = -1  #Definindo o lado da procura
	
	self.linear_velocity = Vector2(speed * searchSide, self.linear_velocity.y); #Mandando ele andar
	wallDetection.body_entered.connect(virar) #Virando quando bate na parede

func chase():
	spriteRend.play("rushing")
	spriteRend.modulate = Color(1.0, 0.533, 0.536, 1.0)
	speed = rushSpeed
	
	if(spriteRend.flip_h == false): 
		searchSide = 1 
	else: searchSide = -1
	
	self.linear_velocity = Vector2(speed * searchSide, self.linear_velocity.y);
	wallDetection.body_entered.connect(virar)
	pass
	

#endregion

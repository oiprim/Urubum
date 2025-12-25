extends RigidBody2D

var speed = 200
var searchSide
@onready var player := $"../Player"
@onready var wallDetection := $DetectWalls
@onready var spriteRend = $enemySprite

@onready var spritePerState = [ #Guardando Sprites
preload("res://Sprites/Urubao.png"), #IDLE -> 0
];


enum STATES { IDLE, SEARCH, HUNT}
var state: STATES = STATES.SEARCH

func _physics_process(_delta):
	spriteRend.scale = Vector2(0.1, 0.1);
	

	match state:
		STATES.IDLE:
			idle();

		STATES.SEARCH:
			search();
			
		STATES.HUNT:
			hunt();

@warning_ignore("unused_parameter")
func virar(body): #Flipar o sprite do inimigo
	spriteRend.flip_h = !spriteRend.flip_h 

#region StatesFunction #definindo cada função do inimigo

func idle():
	spriteRend.texture = spritePerState.get(0); #Setando sprite
	self.linear_velocity = Vector2(0, self.linear_velocity.y); #Definindo que tenho que ficar parado

func search(): #Rondar de um lado para o outro
	if(spriteRend.flip_h == false): 
		searchSide = 1 
	else: searchSide = -1  #Definindo o lado da procura
	
	self.linear_velocity = Vector2(speed * searchSide, self.linear_velocity.y); #Mandando ele andar
	wallDetection.body_entered.connect(virar) #Virando quando bate na parede

func hunt():
	pass
	

#endregion

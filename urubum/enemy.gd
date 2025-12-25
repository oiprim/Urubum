extends RigidBody2D


var speed = 100
var searchSide
@onready var spriteRend = $enemySprite;
@onready var spritePerState = [
preload("res://Sprites/Urubao.png"), ##IDLE -> 0 
preload("res://Sprites/Square - Black.jpg") ##BLOCO PRETO -> 1
];

var maxTimeToFlip : int = 120;
var timeToFlip : int = maxTimeToFlip;

enum STATES { IDLE, SEARCH, JUMP }

var state: STATES = STATES.IDLE

func _physics_process(_delta):
	match state:
		STATES.IDLE:
			pass;
		
		STATES.SEARCH:
			idle()






func idle():
	spriteRend.texture = spritePerState.get(1);
	timeToFlip -= 1;


func searching():
	if(spriteRend.flip_h == false): searchSide = 1
	else: searchSide = -1
	
	self.linear_velocity = Vector2(speed * searchSide, 0);
